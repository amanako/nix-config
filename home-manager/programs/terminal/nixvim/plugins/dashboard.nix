{
	programs.nixvim.plugins.dashboard = {
    enable = true;
    settings = {
      theme = "doom";
      config = {
      	center = [  
      		{  
        		icon = "";  
        		desc = "Find File";
        		action = "Telescope find_files";
        		key = "f";  
      		}  
      		{  
          	icon = "";  
          	desc = "Live Grep";
          	action = "Telescope live_grep";
            key = "g";  
          }  
          {  
            icon = "󰉋";  
            desc = "File Tree";  
            action = "NvimTreeToggle";
            key = "t";  
          }  
          {  
            icon = "󰈆";  
            desc = "Quit";  
            action = "qa";  
            key = "q";  
          }  
        ];  
        footer = [ "Made with ❤️" ];  
      };  
    };  
  };
}
