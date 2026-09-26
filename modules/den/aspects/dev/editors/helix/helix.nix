{den, ...}: {
  den.aspects.dev.editors.helix = {
    description = "Modern modal text editor with built-in LSP and tree-sitter support.";

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
