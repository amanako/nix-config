{den, ...}: {
  den.aspects.editors.helix = {
    stylixHMSettings.targets."helix".enable = false;

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
          lib.mkIf (user.hasAspect den.aspects.optional.bleeding-edge.chaotic)
          pkgs.helix_git;
        ignores = [
          ".build/"
          "!.gitignore"
        ];
      };
    };
  };
}
