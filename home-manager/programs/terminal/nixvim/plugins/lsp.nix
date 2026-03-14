{
	plugins.lspkind.enable = true;
	plugins.lsp-signature.enable = true;
	plugins.lsp.enable = true;

  plugins.lsp.servers = {
    nixd.enable = true;
	  clangd.enable = true;
	  cmake.enable = true;
	  html.enable = true;
  };
   
  plugins.lsp.keymaps = {
  	silent = true;
  	lspBuf = {
      "<leader>ca" = {
  			action = "code_action";
 			  desc = "LSP code action";
  		};
  		"<leader>cr" = {
       action = "rename";
  			desc = "LSP rename";
  	  };
  	};
  };
}
