{inputs, ...}: {
  flake-file.inputs.wallpapers = {
    url = "git+https://codeberg.org/voidptrx/wallpapers";
    flake = false;
  };

  den.aspects.wallpaper-managers.awww.script = {
    # Awww keeps cached actions so preserving directory should reduce load
    persistUser.directories = [".cache/awww"];

    hm = {
      user,
      pkgs,
      lib,
      ...
    }: let
      cfg = user.settings.wallpaper-managers.awww.script;
      wallpapersPath = inputs.wallpapers.outPath;

      # Since systemd services run in minimal environment many core linux utilities are not available
      awwwExe = "awww" |> lib.getExe' pkgs.awww;
      find = "find" |> lib.getExe' pkgs.findutils;
      shuf = "shuf" |> lib.getExe' pkgs.coreutils;

      joinedScriptArgs = cfg.args |> lib.join " ";

      scriptPkg = pkgs.writeShellScriptBin "${cfg.label}" ''
        DIR="${wallpapersPath}"
        img=$( ${find} "$DIR" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.gif" -o -iname "*.webp" -o -iname "*.bmp" \) | ${shuf} -n 1)
        if [ -n "$img" ]; then
          ${awwwExe} img ${joinedScriptArgs} "$img"
        fi
      '';

      inherit (user.settings.wallpaper-managers.awww) service;
    in {
      systemd.user.services.${service.label} = {
        Unit.Description = "Wallpaper rotator";

        Service = {
          ExecStart = "${lib.getExe scriptPkg}";
          Restart = "on-failure";
          RestartSec = 2;

          Type = "oneshot";
        };
      };

      home.packages =
        # To test functionality
        [pkgs.awww]
        ++ [scriptPkg]
        |> lib.optionals cfg.exposePackage;
    };
  };
}
