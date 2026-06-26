{
  den,
  lib,
  inputs,
  ...
}: {
  flake-file.inputs.stylix.url = "github:nix-community/stylix";

  # Following stylix logic, when host imports the aspect configuration is applied for users as well
  # To opt out, override priority for home settings like so:
  #
  #  stylixHMSettings = {lib, ...}: {
  #    enable = lib.mkForce false;
  #  };

  den.aspects.optional.stylix = let
    mergeWithDefaults = settings:
      settings
      ++ [
        {
          enable = true;
          autoEnable = true;
          enableReleaseChecks = false;
        }
      ]
      |> lib.mkMerge;
  in {
    includes = [
      den.aspects.optional.stylix.base-settings
    ];

    nixos = {stylixNixOSSettings, ...}: {
      imports = [inputs.stylix.nixosModules.stylix];

      stylix = stylixNixOSSettings |> mergeWithDefaults;
    };

    provides.to-users.hm = {stylixHMSettings, ...}: {
      stylix = stylixHMSettings |> mergeWithDefaults;
    };
  };
}
