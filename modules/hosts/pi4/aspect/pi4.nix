{den, ...}: {
  den.aspects.pi4 = {
    description = "Pi4 host model B 4GB RAM.";

    includes = [
      den.aspects.core.hardware.raspberry-pi.common
      den.aspects.core.nix.common
      den.aspects.core.nix.lix

      den.aspects.core.disks.disko-rpi
      den.aspects.core.disks.root-btrfs
      den.aspects.core.disks.swap-subvol
      den.aspects.core.impermanence

      den.aspects.security.ssh
    ];
  };
}
