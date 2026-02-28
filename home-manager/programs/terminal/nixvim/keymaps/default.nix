{
	programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>w";
      action = ":w<CR>";
      options = { desc = "Write file"; };
    }
    {
	    mode = "n";
	    key = "<leader>q";
	    action = ":q<CR>";
	    options = { desc = "Quit file"; };
    }
    {  
	    mode = "n";  
	    key = "<leader>e";  
	    action = "<cmd>NvimTreeToggle<CR>";  
	    options = { desc = "Toggle file tree"; };  
    }  
    {  
	    mode = "n";  
	    key = "<leader>sf";  
	    action = "<cmd>Telescope find_files<CR>";  
	  	options = { desc = "Search files"; };  
    }  
    {  
	    mode = "n";  
	    key = "<leader>o";  
	    action = "<cmd>NvimTreeFocus<CR>";  
	    options = { desc = "Focus file tree"; };  
    }
    {
      mode = "n";
      key = "<leader>lp";
      action = "<cmd>lua require('gitsigns').preview_hunk()<CR>";
      options = { desc = "Preview gitsigns"; };
    }
    {
      mode = "n";
      key = "<leader>lg";
      action = "<cmd>LazyGit<CR>";
      options = { desc = "Open lazygit"; };
    }
		{
			mode = "n";
			key = "<leader>zm";
			action = "<cmd>ZenMode<CR>";
			options = { desc = "Go zen-mode"; };
		}
		{
			mode = "n";
			key = "<leader>lf";
			action = "<cmd>Format<CR>";
		  options = { desc = "Format file"; };
	  }
  ];
}
