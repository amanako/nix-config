{
  den,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkOption types;
in {
  den.aspects.core.disks.disko-btrfs-rpi = {
    description = ''
      Disko setup for Raspberry Pi producing a Btrfs SD card image.

      Assembles the RPi boot (FAT, mounted at `/boot`) partition via
      `rpi-boot` together with the disko collector, redirects the Pi firmware
      into the FAT partition root (see `boot.loader.raspberry-pi.firmwarePath`;
      the upstream default `/boot/firmware` would point at a subdirectory the
      Pi boot ROM never reads), and enables disko's image builder so
      `.#<host>-image` (or `just image <host>`) produces a ready-to-flash raw
      SD card image carrying the exact disko layout (btrfs subvolumes
      included). The same layout can still be applied to a real card with
      `.#<host>-disko` via `just d`. The image builder VM runs as
      `aarch64-linux`, so prefer an ARM build host (or aarch64 remote builder);
      on x86_64 it builds via binfmt emulation and is slow.
    '';

    includes = [
      den.aspects.core.disks.disko-collector
      den.aspects.core.disks.image-builder
      den.aspects.core.disks.rpi-boot
    ];

    hostSettings = {
      imageName = mkOption {
        type = types.str;
        default = "nixos";
        description = "Base name of the generated raw disk image file (e.g. `nixos.raw`).";
      };

      imageSize = mkOption {
        type = types.str;
        default = "12G";
        example = "8G";
        description = ''
          Size of the generated raw disk image, as passed to `qemu-img create`.
          The btrfs root partition fills the whole image, so this must fit the
          RPi's store closure plus the swapfile baked in by `swap-subvol`
          (`swapSize`) plus the FAT boot partition. The file is sparse until
          populated, so build with some headroom.
        '';
      };
    };

    nixos = {
      host,
      pkgs,
      ...
    }: let
      cfg = host.settings.core.disks.disko-btrfs-rpi;
    in {
      # The Pi boot ROM only reads the root of the FAT partition. disko mounts
      # that partition at /boot (see rpi-boot), so put the firmware there
      # instead of the upstream default /boot/firmware.
      boot.loader.raspberry-pi.firmwarePath = lib.mkDefault "/boot";

      imports = [
        inputs.disko.nixosModules.disko
      ];

      disko.memSize = lib.mkDefault 2048;

      disko.imageBuilder = {
        enableBinfmt = true;
        # Run the builder VM with native (build-platform) packages and only
        # emulate the target arch inside it. This makes cross-building the
        # image on an x86_64 machine work out of the box.
        kernelPackages = pkgs.buildPackages.linuxPackages;
      };

      disko.devices.disk.main = {
        inherit
          (cfg)
          imageName
          imageSize
          ;
      };
    };
  };
}
