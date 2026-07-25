{
  den,
  lib,
  ...
}: {
  den.aspects.dev.editors.helix = {
    stylixHMSettings.targets."helix".enable = false;

    nushellConfig = {user, ...}:
      lib.optionalString (user.preferences.editor == "hx") ''
        $env.EDITOR = "hx"
      '';

    hm = {
      user,
      pkgs,
      lib,
      ...
    }: {
      programs.helix = {
        enable = true;
        defaultEditor = user.preferences.editor == "hx";
        package =
          lib.mkIf (user.hasAspect den.aspects.extra.bleeding-edge.chaotic)
          pkgs.helix_git;
        ignores = [
          ".build/"
          "!.gitignore"
        ];
      };
    };
  };
}
