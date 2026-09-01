{
  den,
  inputs,
  ...
}: {
  den.aspects.core.disks.disko-rpi = {
    description = ''
      Disko setup for Raspberry Pi: RPi boot partition + btrfs collector.

      Actual partitioning happens when running script accessible as package $HOSTNAME.disko of repository, runnable via `just disko`.
    '';

    includes = [
      den.aspects.core.disks.disko-collector
      den.aspects.core.disks.rpi-boot
    ];

    nixos = {
      imports = [
        inputs.disko.nixosModules.disko
      ];
    };
  };
}
