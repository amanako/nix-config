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
      web-devicons.enable = true;

      telescope = {
        enable = true;
	keymaps = {
          "<leader><leader>" = "find_files";
	};
      };

      lsp = {
        enable = true;

	servers = {
          nixd.enable = true;
	  clangd.enable = true;
	  cmake.enable = true;
	  html.enable = true;
	};
      };

      lsp_lines.enable = true;

      diagnostic.settings = {
        virtual_text = false;
	virtual_lines = {
          only_current_line = true;
	};
      };
    };

    opts = {
      number = true;
      relativenumber = false;
      shiftwidth = 2;
    };

    keymaps = [];

    diagnostic.config = {
      virtual_lines = {
        current_line = true;
      };
      virtual_text = true;
    };

    clipboard.provides.wl-copy.enable = true;
  };
}
