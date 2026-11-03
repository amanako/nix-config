{
  den,
  lib,
  inputs,
  ...
}: {
  flake-file.inputs.stylix.url = "github:nix-community/stylix";

  den.aspects.extra = let
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
    stylix-host = {
      description = "System-wide colour theme management using base16 schemes, powered by nix.";

      includes = [
        den.aspects.extra.stylix-host.base-settings
      ];

      # Include stylix aspect for user.
      # Users can opt out by:
      # stylixHMSettings.enable = false
      # in any aspect.

      provides.to-users.includes = [
        den.aspects.extra.stylix-user
      ];

      nixos = {stylixNixOSSettings, ...}: {
        imports = [inputs.stylix.nixosModules.stylix];

        stylix = stylixNixOSSettings |> mergeWithDefaults;
      };
    };
  };
}
