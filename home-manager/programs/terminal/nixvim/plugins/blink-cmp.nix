{
	blink-cmp = {
    enable = true;
    setupLspCapabilities = true;
    settings = {
      keymap = { preset = "default"; };

      sources = {
        default = [ "lsp" "path" "snippets" "buffer" ];
        providers = {
          buffer.score_offset = -7;
          lsp.fallbacks = [ ];
        };
        cmdline = [ ];
      };

      completion = {  
        keyword = {  
         	range = "prefix"; # or "full"  
         	regex = "[-_]\\|\\k";  
       	};  
       	trigger = {  
         	prefetch_on_insert = false;  
         	show_in_snippet = true;  
         	show_on_keyword = true;  
         	show_on_trigger_character = true;  
       	};  
       	list = {  
         	max_items = 200;  
         	selection = {  
           	preselect = true;  
           	auto_insert = true;  
         	};  
         	cycle = {  
          	from_bottom = true;  
           	from_top = true;  
         	};  
       	};  
       	accept = {  
         	create_undo_point = true;  
         	auto_brackets = {  
           	enabled = true;  
           	default_brackets = [ "(" ")" ];  
           	semantic_token_resolution.enabled = false;  
         	};  
        };  
        menu = {  
         	enabled = true;  
         	min_width = 15;  
         	max_height = 10;  
         	border = "none";  
         	winblend = 0;  
         	winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None";  
         	scrolloff = 2;  
         	scrollbar = true;  
         	direction_priority = [ "s" "n" ];  
         	auto_show = true;  
        };  
        documentation = {  
         	auto_show = true;  
         	window = {  
           	border = "padded";  
           	winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder";  
           	winblend = 0;  
           	max_width = 80;  
           	max_height = 20;  
         	};  
        };  
     	}; 

	    signature = {
        enabled = true;
        window = {  
          border = "padded";  
          winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder";  
        };  
	    };

	    snippets = {  
	      expand.__raw = "function(snippet) vim.snippet.expand(snippet) end";  
	      active.__raw = "function(filter) return vim.snippet.active(filter) end";  
	      jump.__raw = "function(direction) vim.snippet.jump(direction) end";  
	    };

	    appearance = {  
	      use_nvim_cmp_as_default = true; # Fallback to nvim-cmp highlights  
	      nerd_font_variant = "mono";
	      kind_icons = {  
	        Text = "󰉿";  
	        Method = "󰊕";  
	        Function = "󰊕";  
	        Constructor = "󰒓";  
	        Field = "󰜢";  
	        Variable = "󰆦";  
	      };  
	    };
	  };
  };
}
