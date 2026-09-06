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
  * [2. Install NixOS](#2-install-nixos)
  * [3. Install the bootloader manually](#3-install-the-bootloader-manually)
  * [4. First boot & SSH](#4-first-boot--ssh)
- [Deploying updates after first boot](#deploying-updates-after-first-boot)
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

From this repository on your PC configure disko device and run it's corresponding package. For device path use one as it appears on current host:

```bash
# Format card device
sudo nix --accept-flake-config run .#${pi-host}-disko
```

`--mode destroy,format,mount` is baked into the wrapper, so this wipes the card,
formats it, and mounts it at `/mnt`.

### 2. Install NixOS

`nixos-install` applies the pi4 host configuration onto `/mnt`. Either build it
here or flash a system already built elsewhere. Both install commands below
pass `--no-bootloader`; installing from an x86_64 host runs the aarch64
binaries via QEMU binfmt, and `nixos-install`'s chrooted bootloader step fails
there. The store, profile symlink and `/etc/NIXOS` get written correctly; the
bootloader is finished manually right after (next subsection).

**Build locally** (needs this machine to be able to build `aarch64-linux`, see
[Cross-compilation](#cross-compilation-optional)):

```bash
sudo nixos-install --root /mnt --no-bootloader --flake .#pi4
```

**Flash a pre-built system** (built on another machine or present on cache, e.g. because binfmt
emulation isn't set up on current one):

1. On the build host, print the store path instead of creating a `./result`
   symlink:

```bash
export closure=$(nix --accept-flake-config build --no-link --print-out-paths .#nixosConfigurations.${hostname}.config.system.build.toplevel)
```

2. Point `nixos-install` at it instead of `--flake`:

```bash
sudo nixos-install --root /mnt --no-bootloader --system $closure
```

> This command will likely result in an error like:
> chroot: failed to run command ‘/nix/var/nix/profiles/system/activate’: No such file or directory
> chroot: failed to run command ‘/nix/var/nix/profiles/system/sw/bin/bash’: No such file or directory
> meaning /mnt/boot isn't populated, that is card isn't bootable yet. Just continue along and it should be resolved.

### 3. Install the bootloader manually

The chroot `nixos-install` uses can't run the aarch64 `switch-to-configuration`
because the kernel resolves the QEMU binfmt interpreter
(`/run/binfmt/aarch64-linux`, a symlink into the **host's** `/nix/store`) against
the chroot root, and QEMU isn't part of the card's store. Fix it by binding the
needed host dirs into the target, creating the dir the uboot firmware builder
assumes exists, then running the bootloader install inside a plain `chroot`:

```bash
sudo mkdir /mnt/run
sudo mount --bind /run /mnt/run
# host store: bring QEMU binfmt interpreter into pi's store.
sudo mount --bind /nix/store /mnt/nix/store
sudo mount -o remount,bind,ro /nix/store /mnt/nix/store

# 2. The uboot firmware builder copies into /boot/firmware but never creates it so create it ourselves to avoid error.
sudo mkdir -p /mnt/boot/firmware

# 3. Install the bootloader (aarch64 via binfmt inside the chroot)
sudo chroot /mnt /nix/var/nix/profiles/system/bin/switch-to-configuration boot
```

Verify the boot partition got populated (`sudo ls /mnt/boot /mnt/boot/firmware`
should show `extlinux/extlinux.conf`, `config.txt`, DTB files, `start*.elf`,
`bootcode.bin`, the kernel and initrd). When it finishes, unmount everything
and eject:

```bash
sudo umount -R /mnt
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

## Deploying updates after first boot

Flashing is only needed to get the system onto the card. Once booted, update
the Pi like any other NixOS host: switch its running system over SSH. The
machine you run this from (typically the build host) must be able to build
`aarch64-linux` and reach the Pi over SSH with the user that has your key
installed (see [First boot & SSH](#4-first-boot--ssh)):

```bash
sudo nixos-rebuild switch --flake .#pi4 --target-host <user>@pi4
```

Or via `nh`, matching how the other hosts in this repo are deployed:

```bash
nh os switch --accept-flake-config --ask --diff always --show-trace --hostname pi4 --target-host <user>@pi4
```

`--hostname pi4` selects the flake's pi4 configuration and `--target-host`
the machine it gets activated on. If the Pi has no user with your key yet,
install one (or add the key) before first boot.

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
