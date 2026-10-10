{
  den,
  inputs,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
in {
  den.aspects.core.hardware.raspberry-pi.sd-image = {
    description = ''
      Fallback image path for a Raspberry Pi that does not use disko. Imports
      `nixos-raspberrypi`'s `sd-image` module (classic ext4 root, firmware on
      `/boot/firmware`) and exposes the resulting installer image via
      `config.system.build.sdImage`, which `.#<host>-image` (`just image`) picks
      up when the disko aspect is absent.

      Prefer the disko aspect (`disko-btrfs-rpi`) for a btrfs/impermanence
      layout. This aspect defines its own filesystems, so do not combine it
      with `rpi-boot`/disko or with `boot.loader.generic-extlinux-compatible`.
    '';

    includes = [
      den.aspects.core.hardware.raspberry-pi
    ];

    hostSettings = {
      compressImage = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = ''
          Whether the SD card image is zstd-compressed (`.img.zst`) after
          being built, matching `sdImage.compressImage`.
        '';
      };
    };

    nixos = {
      host,
      ...
    }: let
      cfg = host.settings.core.hardware.raspberry-pi.sd-image;
    in {
      imports = [
        inputs.nixos-raspberrypi.nixosModules.${host.settings.core.hardware.raspberry-pi.board}.base
        inputs.nixos-raspberrypi.nixosModules.sd-image
      ];

      sdImage.compressImage = cfg.compressImage;
    };
  };
}