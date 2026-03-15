{ inputs, ... }:

{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  programs.nixvim = {
    imports = [
      ./colorschemes
      ./dependencies
      ./keymaps
      ./opts
      ./extraConfig
      ./plugins
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
}
