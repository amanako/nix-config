{
	programs.nixvim.plugins.actions-preview.enable = true;  
  programs.nixvim.plugins.lsp.keymaps.extra = [  
    {  
      key = "<leader>ca";  
      action.__raw = "require('actions-preview').code_actions";  
      options = { desc = "LSP code actions (actions-preview)"; };  
    }  
		# Pending fix
		# {  
		#	  key = "<leader>cA";  
		#	  action.__raw = "require('telescope.builtin').code_actions";  
		#   options.desc = "LSP code actions (all in buffer)";  
		# }  
  ];
}
