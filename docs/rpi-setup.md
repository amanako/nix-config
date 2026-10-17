This guide details out installation on raspberry pi version 4. Adjust according to preferences.

Throughout this document the Raspberry Pi host is referred to as `{pi-host}`, which
stands for its name in this repo — the `nixosConfigurations.{pi-host}` /
`net.hostName` attribute and the `diskoScripts.{pi-host}` / `vms.{pi-host}` /
`images.{pi-host}` flake outputs derived from it (`just d`, `just vm`, `just image`,
`just rs`).
Substitute the actual name for your Raspberry Pi host in every command below.

The Pi host uses **disko** for partitioning (btrfs root with subvolumes) with
**impermanence** (fresh btrfs root on every boot, selective persistence), same
as the other hosts — but with a Raspberry Pi-specific `rpi-boot` FAT32 partition
instead of an EFI System Partition, since the RPi boot ROM does not use UEFI.

<!-- toc -->

- [Prerequisites](#prerequisites)
  * [Cross-compilation (optional)](#cross-compilation-optional)
  * [A live environment](#a-live-environment)
  * [The target SD card's device path](#the-target-sd-cards-device-path)
- [Partition layout](#partition-layout)
- [Build a bootable SD card image (recommended)](#build-a-bootable-sd-card-image-recommended)
  * [Build the image](#build-the-image)
  * [Burn the image](#burn-the-image)
  * [Resize the root on first boot](#resize-the-root-on-first-boot)
  * [How the boot files are laid out](#how-the-boot-files-are-laid-out)
- [Alternative: partition and install with disko](#alternative-partition-and-install-with-disko)
  * [1. Run the `diskoScripts.{pi-host}` package](#1-run-the-diskoscriptspi-host-package)
  * [2. Install NixOS](#2-install-nixos)
  * [3. Install the bootloader manually](#3-install-the-bootloader-manually)
  * [4. First boot & SSH](#4-first-boot--ssh)
- [Deploying updates after first boot](#deploying-updates-after-first-boot)
- [Device naming notes](#device-naming-notes)

<!-- tocstop -->

## Prerequisites

### Cross-compilation (optional)

The image is assembled by disko's image builder, which boots an aarch64 VM
(`qemu-system-aarch64` on a `virt` machine, using KVM when run on aarch64).
Building the image on an x86_64 machine emulates that VM via binfmt — it works
but is slow, so prefer a native aarch64 build host (the Pi itself, once booted)
when re-flashing. Building the aarch64 closure also requires either
`boot.binfmt.emulatedSystems = ["aarch64-linux"]` on the build host or the
aarch64 binary cache:

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
`/dev/mmcblk0` (an internal card reader). Note it; you'll use it when burning the
image.

## Partition layout

| Partition | Type | Filesystem | Size | Mount |
| --------- | ---- | ---------- | ---- | ----- |
| `BOOT`    | `0C01` (W95 FAT32 LBA) | vfat | 256M (default) | `/boot` |
| `root`    | btrfs | btrfs | 100% of remaining | — (container for subvolumes) |
| &nbsp;`/root`   | btrfs subvolume | | | `/` (fresh per boot) |
| &nbsp;`/nix`    | btrfs subvolume | | | `/nix` |
| &nbsp;`/swap`   | btrfs subvolume (nodatacow) | | swapfile, 4G (default set for the Pi host) | `/swap` |
| &nbsp;`/nix/persist/system` | btrfs subvolume | | | persistent state |

The layout is assembled from `den.aspects.core.disks.disko-btrfs-rpi` (collector +
`rpi-boot` instead of `esp`), `root-btrfs`, `swap-subvol`, and `impermanence`,
all already included by the Pi host aspect. The upstream installer image you may
use as a temporary boot environment has a different layout (a FAT firmware
partition plus an ext4 root); it is not Btrfs. The declarative layout here is
Btrfs on the root partition, with the FAT boot partition kept separate. The
disks live under `modules/den/aspects/core/disks/`; see `docs/disks.md` for how
the `diskoConfig` quirk folds them together.

## Build a bootable SD card image (recommended)

The Pi disk aspect configures disko's **image builder**, so the exact disko
layout (FAT boot partition + btrfs root with subvolumes + installed bootloader)
is produced as a raw disk image you can flash directly. No separate `disko`,
`nixos-install`, or chroot fiddling on the Pi is needed. This works for every
disko host: `.#images.<host>` / `just image <host>` emits a bootable image of
that host's own layout (use it to re-image the Pi or any other machine).

### Build the image

```bash
just image {pi-host}
```

or, to see the derivation being built:

```bash
nix --accept-flake-config build .#images.{pi-host} --print-build-logs
```

disko creates an image of `core.disks.disko-btrfs-rpi.imageSize` (default `12G`,
set it in the host entry if your system stores more data), partitions and formats
it, copies the system closure in, and runs the bootloader install — all inside a
build VM (see [Cross-compilation](#cross-compilation-optional) for caveats about
building on x86_64). The result is a directory containing the raw image, e.g.
`result/nixos.raw` (file name comes from `core.disks.disko-btrfs-rpi.imageName`).

### Burn the image

```bash
# Directly with dd (raw image, no intermediate file)
sudo dd if=result/nixos.raw of=/dev/sdX bs=4M conv=fsync status=progress
# or with a graphical flasher
nix run nixpkgs#caligula -- burn result/nixos.raw
```

### Resize the root on first boot

The btrfs root partition fills the whole fixed-size image, so it won't use all of
a larger card. After first boot (over SSH), expand it to the card:

```bash
sudo growpart /dev/mmcblk0 2
sudo btrfs filesystem resize max /
```

### How the boot files are laid out

The Pi aspect sets `boot.loader.raspberry-pi.firmwarePath` to `/boot`. The FAT
partition is mounted at `/boot`, so firmware files (`config.txt`, DTBs,
`start*.elf`, and `bootcode.bin`) land at the root of that partition, alongside
generic extlinux files under `extlinux/` and kernel/initrd files under `nixos/`
(useGenerationDeviceTree is off, so device trees are generated each boot into
`firmwarePath`). The upstream default `/boot/firmware` would instead put the
firmware in a subdirectory the Pi boot ROM never reads, leaving the card unbootable.

## Alternative: partition and install with disko

If you'd rather lay out a real card directly (and install onto it by hand), use
the same disko config as the image. This wipes the SD card and lays out the full
64GB using the Pi host's disko config. **Run it from your PC**, with the card
connected — not from the Pi while it's running off that card.

### 1. Run the `diskoScripts.{pi-host}` package

From this repository on your PC configure disko device and run it's corresponding package. For device path use one as it appears on current host:

```bash
# Format card device
sudo nix --accept-flake-config run .#diskoScripts.{pi-host}
```

`--mode destroy,format,mount` is baked into the wrapper, so this wipes the card,
formats it, and mounts it at `/mnt`. The FAT partition is mounted at `/mnt/boot`;
the Btrfs root partition is mounted through its subvolumes (`/root` at `/mnt`,
`/nix` at `/mnt/nix`, and so on).

### 2. Install NixOS

`nixos-install` copies the Pi system closure into `/mnt` and registers it as the
installed system. Either build it here or use a system built elsewhere. Both
commands pass `--no-bootloader`; the boot files are installed manually in the
next subsection. Do not bind the live system's `/nix/store` over
`/mnt/nix/store` until after this command: that would hide the target's store
while the installer copies the system closure.

**Build locally** (needs this machine to be able to build `aarch64-linux`, see
[Cross-compilation](#cross-compilation-optional)):

```bash
sudo nixos-install --root /mnt --no-bootloader --flake .#{pi-host}
```

**Flash a pre-built system** (built on another machine or present on cache, e.g. because binfmt
emulation isn't set up on current one):

1. On the build host, print the store path instead of creating a `./result`
   symlink:

```bash
export closure=$(nix --accept-flake-config build --no-link --print-out-paths .#nixosConfigurations.{pi-host}.config.system.build.toplevel)
```

2. Point `nixos-install` at it instead of `--flake`:

```bash
sudo nixos-install --root /mnt --no-bootloader --system $closure
```

If `nixos-install` reports that it cannot run
`/nix/var/nix/profiles/system/activate` or
`/nix/var/nix/profiles/system/sw/bin/bash`, **do not treat that as a successful
install without checking the target**. These paths are in the installed system;
their error does not mean the FAT boot partition is empty. Check that the
system profile points to a closure whose activation script and Bash are present
on the target Btrfs store:

```bash
sudo sh -c '
  system=$(readlink /mnt/nix/var/nix/profiles/system) || exit 1
  case "$system" in
    /nix/store/*) test -x "/mnt$system/activate" && test -x "/mnt$system/sw/bin/bash" ;;
    *) exit 1 ;;
  esac
'
```

If this check fails, stop and rerun `nixos-install`; do not eject the card. If
it succeeds, the system closure was copied and registered, and you can continue
to the manual bootloader step.

### 3. Install the bootloader manually

The chroot needs the live system's QEMU binfmt handler and Nix store to execute
the aarch64 bootloader builder. Bind them **after** `nixos-install` has copied
the target closure, then run the bootloader install inside a plain `chroot`:

```bash
sudo mkdir -p /mnt/run /mnt/nix/store
sudo mount --bind /run /mnt/run
sudo mount --bind /nix/store /mnt/nix/store
sudo mount -o remount,bind,ro /nix/store /mnt/nix/store
sudo env NIXOS_INSTALL_BOOTLOADER=1 chroot /mnt /nix/var/nix/profiles/system/bin/switch-to-configuration boot
```

`boot.loader.raspberry-pi.firmwarePath` is `/boot`, so the firmware builder
writes into the FAT partition root (see [How the boot files are laid out](#how-the-boot-files-are-laid-out))
— there is no `/boot/firmware` subdirectory on this layout.

Verify the boot partition got populated (`sudo ls /mnt/boot` should show
`extlinux/`, `nixos/`, `config.txt`, DTB files, `start*.elf`, and
`bootcode.bin`; there should not be a nested `firmware/` directory). When it
finishes, unmount everything and eject:

```bash
sudo umount -R /mnt
sudo eject /dev/sdX
```

### 4. First boot & SSH

Before relying on SSH, make sure the Pi config has a user with your SSH public
key in `openssh.authorizedKeys.keys` (see how the other users in this repo do
it), since `PasswordAuthentication = false` and the Pi has no interactive
login set up. Configure that in the config and rebuild before first boot, or add
the key to the freshly installed system ahead of time.

Because the Pi host includes the **USB gadget Ethernet** aspect
(`core.hardware.usb-gadget-ether-device`), plugging the Pi into your PC over a
USB-C cable makes it appear as a USB Ethernet adapter — useful for reaching it
headlessly on first boot before it joins the Wi-Fi network via iwd.

## Deploying updates after first boot

Flashing is only needed to get the system onto the card. Once booted, update
the Pi like any other NixOS host: switch its running system over SSH. The
machine you run this from (typically the build host) must be able to build
`aarch64-linux` and reach the Pi over SSH with the user that has your key
installed (see [First boot & SSH](#4-first-boot--ssh)):

```bash
sudo nixos-rebuild switch --flake .#{pi-host} --target-host {user}@{pi-host}
```

Or via `nh`, matching how the other hosts in this repo are deployed:

```bash
nh os switch --accept-flake-config --ask --diff always --show-trace --hostname {pi-host} --target-host {user}@{pi-host}
```

`--hostname {pi-host}` selects the flake's Pi configuration and `--target-host`
the machine it gets activated on. If the Pi has no user with your key yet,
install one (or add the key) before first boot.

## Device naming notes

- The RPi kernel always names its SD card `/dev/mmcblk0`, partitions
  `/dev/mmcblk0p1`, `/dev/mmcblk0p2`. This is determined by the MMC controller
  and isn't configurable.
- The Pi config references `/dev/mmcblk0` (whole disk for `devicePath`) and
  `/dev/mmcblk0p2` (btrfs root, for impermanence's `disk-partition`). Neither
  changes after flashing; they describe what the Pi sees while booting, not what
  the card looks like in another machine's reader.
- Impermanence's `disk-partition` setting is only consulted at boot by the
  rolling-root initrd service — a `nixos-rebuild switch` on the Pi doesn't need
  to match your PC's device naming.
