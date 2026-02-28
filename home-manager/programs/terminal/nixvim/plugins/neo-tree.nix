{
	plugins.nvim-tree = {  
    enable = true;  
    autoClose = true;  
    settings = {  
      disable_netrw = true;  
      hijack_netrw = false;  
      update_focused_file = {  
        enable = true;  
        update_root = true;  
      };  
      git = {  
        enable = true;  
        ignore = false;  
      };  
      view = {  
        width = 30;  
        side = "left";  
      };  
    };  
  };
}
