{
  den,
  inputs,
  ...
}: {
  flake-file.inputs.impermanence.url = "github:nix-community/impermanence";

  den.aspects.core.impermanence = {
    includes = [
      den.aspects.core.impermanence.btrfs
      den.aspects.core.impermanence.classes
    ];

    nixos = {
      lib,
      host,
      ...
    }: {
      imports = [inputs.impermanence.nixosModules.impermanence];
      fileSystems =
        {
          "${host.impermanence.persistenceDir}".neededForBoot = true;
        }
        // lib.optionalAttrs (!host.impermanence.enableHome) {
          "/home".neededForBoot = true;
        };
    };
  };

  den.schema.host.includes = [
    (
      {host}:
        if host.impermanence.enableSystem
        then den.aspects.core.impermanence
        else {}
    )
  ];
}
