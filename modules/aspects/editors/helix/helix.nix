{
  den.aspects.editors._.helix = {
    homeManager = {
      programs.helix = {
        enable = true;
        ignores = [
          ".build/"
          "!.gitignore"
        ];
      };
    };
  };
}
