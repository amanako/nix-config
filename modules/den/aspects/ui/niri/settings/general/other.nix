{lib, ...}: let
  inherit
    (lib)
    mkOption
    types
    ;
in {
  niri.other = {
    # Stylix's gtksourceview target patches gtksourceview itself via a local
    # override, which changes its derivation and forces
    # rebuilds of every package that depends on it (e.g. inkscape) instead of
    # using the binary cache. Disabling it in both nixos and hm solves
    # the problem because each applies its own overlay.
    stylixNixOSSettings.targets."gtksourceview".enable = false;
    stylixHMSettings.targets."gtksourceview".enable = false;

    userSettings = {user, ...}: let
      cfg = user.settings.niri.other;
    in {
      cursorName = mkOption {
        type =
          if cfg.cursorPackage == null
          then types.nullOr types.str
          else types.str;
        default = lib.mkIf cfg.cursorPackage == null null;
        example = "Adwaita";
        description = ''
          Cursor theme name used by niri and the `XCURSOR_THEME` session variable.
          When null, niri's default cursor is used and no cursor package is installed.
        '';
      };

      cursorPackage = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "adwaita-icon-theme";
        description = ''
          Nixpkgs package name providing `cursorName`, resolved as `pkgs.''${cursorPackage}`.
          A package name and not a derivation because `pkgs` is not in scope in entries.
          Required when `cursorName` is set.
        '';
      };
    };

    hm = {
      user,
      pkgs,
      lib,
      ...
    }: let
      inherit (user.settings.niri.other) cursorName cursorPackage;

      cursorThemePackage =
        lib.attrByPath
        (lib.splitString "." cursorPackage)
        (throw "no package named \"${cursorPackage}\" in nixpkgs (cursor package)")
        pkgs;
    in
      lib.optionalAttrs (cursorName != null) {
        home.packages = [
          cursorThemePackage
        ];
      };

    niriSettings = {
      user,
      lib,
      ...
    }: let
      inherit (user.settings.niri.other) cursorName;
    in {
      overview.workspace-shadow.enable = false;

      # csd = client side decoration
      # When true, windows will be rectangular and omit csd
      prefer-no-csd = false;

      # Don't show keys at startup
      hotkey-overlay.skip-at-startup = true;

      cursor =
        {
          hide-after-inactive-ms = 3000;
          hide-when-typing = true;
          size = 42;
        }
        // lib.optionalAttrs (cursorName != null) {
          theme = cursorName;
        };
    };
  };
}
