{ inputs, ... }:

{
  flake.hmModules.nixvim = {
    imports = [
      inputs.nixvim.homeModules.nixvim
    ];

    programs.nixvim = {
      imports = [
        ./_colorschemes
        ./_dependencies
        ./_keymaps
        ./_opts
        ./_extraConfig
        ./_plugins
      ];

      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      wrapRc = true;

      globals = {
        mapleader = " ";
      };
    };
  };
}
