This guide details out installation on raspberry pi version 4. Adjust according to preferences.

The pi4 host uses **disko** for partitioning (btrfs root with subvolumes) with
**impermanence** (fresh btrfs root on every boot, selective persistence), same
as the other hosts — but with a Raspberry Pi-specific `rpi-boot` FAT32 partition
instead of an EFI System Partition, since the RPi boot ROM does not use UEFI.

<!-- toc -->

- [Prerequisites](#prerequisites)
  * [Cross-compilation (optional)](#cross-compilation-optional)
  * [A live environment](#a-live-environment)
  * [The target SD card's device path](#the-target-sd-cards-device-path)
- [Partition layout](#partition-layout)
- [Quick path: flash a pre-built installer image](#quick-path-flash-a-pre-built-installer-image)
- [Declarative path: partition with disko](#declarative-path-partition-with-disko)
  * [1. Run the `pi4-disko` package](#1-run-the-pi4-disko-package)
  * [2. Mount the freshly formatted card](#2-mount-the-freshly-formatted-card)
  * [3. Install NixOS](#3-install-nixos)
  * [4. First boot & SSH](#4-first-boot--ssh)
- [Device naming notes](#device-naming-notes)

<!-- tocstop -->

## Prerequisites

### Cross-compilation (optional)

If you build the pi4 image on another host, make sure that host builds with
`boot.binfmt.emulatedSystems = ["aarch64-linux"]`. If not, add and rebuild:

```nix
boot.binfmt.emulatedSystems = ["aarch64-linux"];
```

### A live environment

Partitioning and installing require a running Linux environment that can see the
SD card. Your regular PC works fine: plug the SD card (or card+adapter) into a
card reader and connect it. You do **not** need to boot the Pi itself.

### The target SD card's device path

On the live environment (your PC), find the card's device path:

```bash
lsblk -o NAME,SIZE,MODEL
```

It will typically appear as `/dev/sda` or `/dev/sdb` (a USB card reader), or
`/dev/mmcblk0` (an internal card reader). Note it; you'll use it below.

## Partition layout

| Partition | Type | Filesystem | Size | Mount |
| --------- | ---- | ---------- | ---- | ----- |
| `BOOT`    | `0C01` (W95 FAT32 LBA) | vfat | 256M (default) | `/boot` |
| `root`    | btrfs | btrfs | 100% of remaining | `/` on tmpfs |
| &nbsp;`/root`   | btrfs subvolume | | | `/` (fresh per boot) |
| &nbsp;`/nix`    | btrfs subvolume | | | `/nix` |
| &nbsp;`/swap`   | btrfs subvolume (nodatacow) | | swapfile, 4G (default set for pi4) | `/swap` |
| &nbsp;`/nix/persist/system` | btrfs subvolume | | | persistent state |

The layout is assembled from `den.aspects.core.disks.disko-rpi` (collector +
`rpi-boot` instead of `esp`), `root-btrfs`, `swap-subvol`, and `impermanence`,
all already included by the pi4 host aspect. The disks live under
`modules/den/aspects/core/disks/`; see `docs/disks.md` for how the `diskoConfig`
quirk folds them together.

## Quick path: flash a pre-built installer image

If you don't want declarative partitioning yet (e.g. just to get the pi4
booted to try things out), flash the upstream installer image instead:

1. Build the image

```bash
nix --accept-flake-config --always-allow-substitutes build github:nvmd/nixos-raspberrypi#installerImages.rpi4
```

2. Burn it to the SD card

```bash
nix run nixpkgs#caligula -- burn <PATH_TO_COMPRESSED_IMAGE>
```

3. Follow through the on-screen setup, then move on to configuring users/SSH
   (see below) before relying on remote access.

Note: this image's root partition only uses a few GB — the rest of a 64GB card
is wasted. Switching to the [declarative disko path](#declarative-path-partition-with-disko)
later reclaims that space.

## Declarative path: partition with disko

This wipes the SD card and lays out the full 64GB using the pi4 host's disko
config. **Run it from your PC**, with the card connected — not from the Pi while
it's running off that card.

### 1. Run the `pi4-disko` package

From this repository on your PC:

```bash
nix run .#pi4-disko -- /dev/sdX
```

Replace `/dev/sdX` with the card's device path (see
[above](#the-target-sd-cards-device-path)). The path you pass on the command
line is used *for this invocation only*; the config's
`settings.core.disks.disko-collector.devicePath` (`/dev/mmcblk0`, what the Pi
itself sees) is what matters at boot time.

`--mode destroy,format,mount` is baked into the wrapper, so this wipes the card,
formats it, and mounts it.

> If the card lives in a USB reader on your PC it will likely be `/dev/sda`
> etc., not `/dev/mmcblk0`. That's expected and fine for a one-off use; the Pi's
> own config stays `/dev/mmcblk0`.

### 2. Mount the freshly formatted card

After disko runs, its mounts may not survive to a separate `nixos-install`
invocation, so mount the partitions explicitly:

```bash
sudo mount /dev/sdX2 /mnt        # btrfs root
sudo mount /dev/sdX1 /mnt/boot   # vfat boot
```

### 3. Install NixOS

```bash
sudo nixos-install --root /mnt --flake .#pi4
```

This applies the pi4 host configuration onto `/mnt`. When it finishes, unmount
and eject:

```bash
sudo umount /mnt/boot /mnt
sudo eject /dev/sdX
```

### 4. First boot & SSH

Before relying on SSH, make sure the pi4 config has a user with your SSH public
key in `openssh.authorizedKeys.keys` (see how `lunar-scar` does it on other
hosts), since `PasswordAuthentication = false` and the Pi has no interactive
login set up. Configure that in the config and rebuild before first boot, or add
the key to the freshly installed system ahead of time.

Because pi4 has the **USB gadget** enabled (`enableUsbGadget = true`), plugging
the Pi into your PC over a USB-C cable makes it appear as a USB Ethernet
adapter — useful for reaching it headlessly on first boot before it joins the
Wi-Fi network via iwd.

## Device naming notes

- The RPi kernel always names its SD card `/dev/mmcblk0`, partitions
  `/dev/mmcblk0p1`, `/dev/mmcblk0p2`. This is determined by the MMC controller
  and isn't configurable.
- The pi4 config references `/dev/mmcblk0` (whole disk for `devicePath`) and
  `/dev/mmcblk0p2` (btrfs root, for impermanence's `disk-partition`). Neither
  changes after flashing; they describe what the Pi sees while booting, not what
  the card looks like in another machine's reader.
- Impermanence's `disk-partition` setting is only consulted at boot by the
  rolling-root initrd service — a `nixos-rebuild switch` on the Pi doesn't need
  to match your PC's device naming.
