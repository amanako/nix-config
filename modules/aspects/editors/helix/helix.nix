{
  flake-file = {
    inputs.helix.url = "github:helix-editor/helix";

    nixConfig = {
      extra-substituters = ["https://helix.cachix.org"];
      extra-trusted-public-keys = ["helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="];
    };
  };

  den.aspects.editors.provides.helix.homeManager.programs.helix = {
    enable = true;
    ignores = [
      ".build/"
      "!.gitignore"
    ];
  };
}
