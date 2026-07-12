{
  inputs,
  lib,
  ...
}: {
  flake-file.inputs.wallpapers = {
    url = "git+https://codeberg.org/voidptrx/wallpapers";
    flake = false;
  };

  den.aspects.everyday.wallpaper-managers.awww.script = {
    # Awww keeps cached actions so preserving directory should reduce load
    persistUser.directories = [".cache/awww"];

    userSettings = {
      label = lib.mkOption {
        type = lib.types.str;
        default = "awww-randomizer";
        example = "wallpaper-switch";
        description = "Name to use for the script.";
      };

      args = lib.mkOption {
        type = lib.types.listOf lib.types.str;
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

    hm = {
      user,
      pkgs,
      lib,
      ...
    }: let
      cfg = user.settings.everyday.wallpaper-managers.awww.script;
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

      inherit (user.settings.everyday.wallpaper-managers.awww) service;
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
        [pkgs.awww]
        ++ [scriptPkg]
        |> lib.optionals cfg.exposePackage;
    };
  };
}
