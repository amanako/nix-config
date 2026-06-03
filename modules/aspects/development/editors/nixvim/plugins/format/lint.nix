{
  nixvim.plugins.lint = {user, ...}: {
    homeManager.programs.nixvim.plugins.lint = {
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
  };
}
