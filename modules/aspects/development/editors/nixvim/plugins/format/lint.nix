{
  nixvim.plugins.lint = {user, ...}: {
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

      autoInstall = {
        enable = true;
      };
    };
  };
}
