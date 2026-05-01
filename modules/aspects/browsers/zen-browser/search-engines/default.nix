{
  zen-browser.search = {
    homeManager = {
      pkgs,
      lib,
      ...
    }: {
      programs.zen-browser.profiles."*".search = let
        iconSize = "48"; # Possible values: 16, 22, 24, 32, 42, 48, 64, 84, 96
        iconBasePath = "${pkgs.papirus-icon-theme}/share/icons/Papirus/${iconSize}x${iconSize}";
        defaultIcon = "${iconBasePath}/apps/distributor-logo-nixos.svg"; # Fallback icon to use if none specified
        mkEngines = engines:
          builtins.mapAttrs (_: engine: {
            inherit (engine) name;
            icon = engine.icon or defaultIcon;

            urls = [
              {
                inherit (engine) template;
              }
            ];

            definedAliases = engine.aliases;
          })
          engines;

        engineFiles = [
          ./_dictionaries.nix
          ./_wiki.nix
          ./_nixos.nix
        ];

        # Merge all files/modules as attributes passing them iconBasePath to allow for choosing of icons
        rawEngines = lib.attrsets.mergeAttrsList (
          map (file: import file {inherit iconBasePath;}) engineFiles
        );
      in {
        force = true;
        default = "ddg";
        privateDefault = "ddg";
        engines = mkEngines rawEngines;
      };
    };
  };
}
