{lib, ...}: {
  den.aspects.wallpaper-managers.awww.script.userSettings = let
    inherit
      (lib)
      mkOption
      types
      ;
  in {
    label = mkOption {
      type = lib.types.str;
      default = "awww-randomizer";
      example = "wallpaper-switch";
      description = "Name to use for the script.";
    };

    args = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [
        "--transition-type wave"
        "--resize=fit"
      ];
      description = "Arguments to pass to the script. Reference: https://codeberg.org/LGFae/awww#usage.";
    };

    exposePackage = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = false;
      description = "Whether to expose script package for manual invoking or testing.";
    };
  };
}
