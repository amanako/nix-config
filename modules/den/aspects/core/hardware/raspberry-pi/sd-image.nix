{
  den,
  lib,
  inputs,
  ...
}: {
  den.aspects.core.hardware.raspberry-pi.sd-image = {
    description = ''
      Fallback to `nixos-raspberrypi`'s `sd-image` module (classic ext4 root, firmware on
      `/boot/firmware`) for cases where disko is not used. Prefer
      `disko-btrfs-rpi` for btrfs/impermanence.
    '';

    nixos = {host, ...}: let
      cond = !(host.hasAspect den.aspects.core.disks.disko);
    in {
      imports = lib.optional cond inputs.nixos-raspberrypi.nixosModules.sd-image;
    };
  };
}
