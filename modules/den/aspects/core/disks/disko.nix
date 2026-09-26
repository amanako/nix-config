{
  den,
  inputs,
  ...
}: {
  flake-file.inputs.disko.url = "github:nix-community/disko";

  den.aspects.core.disks.disko = {
    description = ''
      Community tool for declarative disk partitioning on nixos.

      Actual partitioning happens when running script accessible as package $HOSTNAME.disko of repository, runnable via `just disko`.
    '';

    includes = [
      den.aspects.core.disks.disko-collector
      den.aspects.core.disks.esp
    ];

    nixos = {
      imports = [
        inputs.disko.nixosModules.disko
      ];
    };
  };
}
