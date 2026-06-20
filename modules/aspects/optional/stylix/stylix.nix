{
  den,
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

  den.aspects.optional.stylix = {
    includes = [
      den.aspects.optional.stylix.base-settings
    ];

    nixos = {
      lib,
      stylixNixOSSettings,
      ...
    }: {
      imports = [inputs.stylix.nixosModules.stylix];

      stylix = lib.mkMerge (stylixNixOSSettings
        ++ [
          {
            enable = true;
            autoEnable = true;
            enableReleaseChecks = false;
          }
        ]);
    };

    provides.to-users.homeManager = {
      lib,
      stylixHMSettings,
      ...
    }: {
      stylix = lib.mkMerge (stylixHMSettings
        ++ [
          {
            enable = true;
            autoEnable = true;
            enableReleaseChecks = false;
          }
        ]);
    };
  };
}
