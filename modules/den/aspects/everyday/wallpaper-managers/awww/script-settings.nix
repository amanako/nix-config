{lib, ...}: {
  den.aspects.wallpaper-managers.awww.script.userSettings = let
    inherit
      (lib)
      mkOption
      types
      ;
  in {
    label = mkOption {
      default = "awww-randomizer";
      example = "wallpaper-switch";
      type = lib.types.str;
      description = "Name to use for the script";
    };

    args = mkOption {
      default = [];
      example = [
        "--transition-type wave"
        "--resize=fit"
      ];
      type = types.listOf types.str;
      description = ''
        Arguments to pass to the script. Reference: https://codeberg.org/LGFae/awww#usage.
      '';
    };

    exposePackage =
      lib.mkEnableOption "expose script as a home manager package"
      // {
        default = true;
        description = "This option is great one-time invoking function and testing functionality";
      };
  };
}
