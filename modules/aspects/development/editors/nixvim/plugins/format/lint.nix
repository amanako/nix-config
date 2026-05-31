{
  nixvim.plugins.homeManager.programs.nixvim.plugins.lint = {
    enable = true;
    lintersByFt = {
      nix = [
        "statix"
      ];
      cpp = [
        "cpplint"
      ];
    };

    autoInstall = {
      enable = true;
    };
  };
}
