{
  inputs,
  den,
  lib,
  ...
}: {
  flake.den = den;

  flake-file.inputs.wallpapers = {
    url = "git+https://codeberg.org/voidptrx/wallpapers";
    flake = false;
  };

  den.aspects.wallpaper-managers._.awww = {config, ...}: {
    imports = [
      {
        options.exposeScriptAsPackage =
          lib.mkEnableOption "expose awww script as home package"
          // {
            default = true;
          };
      }
    ];

    homeManager = {
      pkgs,
      lib,
      ...
    }: let
      wallpapersPath = inputs.wallpapers.outPath;

      # Since systemd services run in minimal environment many core linux utilies are not available
      awwwExe = lib.getExe' pkgs.awww "awww";
      find = lib.getExe' pkgs.findutils "find";
      shuf = lib.getExe' pkgs.coreutils "shuf";

      defaultScript = pkgs.writeShellScriptBin "awww-random" ''
        DIR="${wallpapersPath}"
        img=$( ${find} "$DIR" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.gif" -o -iname "*.webp" -o -iname "*.bmp" \) | ${shuf} -n 1)
        if [ -n "$img" ]; then
          ${awwwExe} img --transition-fps 144 --transition-type wave --transition-angle 225 --resize=fit "$img"
        fi
      '';
    in {
      systemd.user.services.awww-random = {
        Unit.Description = "Wallpaper rotator";

        Service = {
          ExecStart = "${lib.getExe defaultScript}";
          Restart = "on-failure";
          RestartSec = 2;

          Type = "oneshot";
        };
      };

      home.packages = lib.optional config.exposeScriptAsPackage defaultScript;
    };
  };
}
