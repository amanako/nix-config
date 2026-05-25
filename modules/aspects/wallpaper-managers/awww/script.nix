{
  inputs,
  den,
  lib,
  ...
}: {
  flake-file.inputs.wallpapers = {
    url = "git+https://codeberg.org/voidptrx/wallpapers";
    flake = false;
  };

  den.schema.user.includes = [
    (
      {user, ...}:
        if user.awww.enable
        then den.aspects.wallpaper-managers._.awww
        else {}
    )
  ];

  den.aspects.wallpaper-managers._.awww.homeManager = {
    user,
    pkgs,
    lib,
    ...
  }: let
    wallpapersPath = inputs.wallpapers.outPath;

    # Since systemd services run in minimal environment many core linux utilies are not available
    awwwExe = lib.getExe' pkgs.awww "awww";
    find = lib.getExe' pkgs.findutils "find";
    shuf = lib.getExe' pkgs.coreutils "shuf";

    joinedScriptArgs = lib.join " " user.awww.script.args;

    scriptPkg = pkgs.writeShellScriptBin "${user.awww.script.label}" ''
      DIR="${wallpapersPath}"
      img=$( ${find} "$DIR" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.gif" -o -iname "*.webp" -o -iname "*.bmp" \) | ${shuf} -n 1)
      if [ -n "$img" ]; then
        ${awwwExe} img ${joinedScriptArgs} "$img"
      fi
    '';

    service = user.awww.service.label;
  in {
    systemd.user.services.${service} = {
      Unit.Description = "Wallpaper rotator";

      Service = {
        ExecStart = "${lib.getExe scriptPkg}";
        Restart = "on-failure";
        RestartSec = 2;

        Type = "oneshot";
      };
    };

    home.packages =
      lib.optional user.awww.script.exposePackage scriptPkg
      ++ [
        # To test functionality
        pkgs.awww
      ];
  };
}
