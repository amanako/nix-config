{
  nixvim.plugins.lint = {
    hm.programs.nixvim.plugins.lint = {
      enable = true;
      lintersByFt = {
        nix = [
          "statix"
        ];
        cpp = [
          "cpplint"
        ];
      };

      autoInstall.enable = false;
    };
  };
}
