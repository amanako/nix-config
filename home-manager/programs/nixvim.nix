{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    vimdiffAlias = true;
    wrapRc = true;

    globals = {
      mapleader = " ";
    };

    colorschemes.gruvbox.enable = true;

    plugins = {
      lualine.enable = true;
    };

    opts = {
      number = true;
      relativenumber = false;
      shiftwidth = 2;
    };

    keymaps = [];
  };
}
