{ inputs, ... }:

{
  imports = [ 
		inputs.nixvim.homeModules.nixvim
		./colorschemes
		./dependencies
		./keymaps
		./opts
		./plugins
	];

  programs.nixvim = {
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
