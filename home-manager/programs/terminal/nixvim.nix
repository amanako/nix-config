{ inputs, pkgs, ... }:

{
  imports = [ inputs.nixvim.homeModules.nixvim ];

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

    colorschemes.gruvbox.enable = true;

    plugins = {
      lualine.enable = true;
      web-devicons.enable = true;
 
      lazygit = {
        enable = true;
        settings = {
          floating_window_winblend = 0;
          floating_window_scaling_factor = 0.9;
        };
      };

      gitsigns = {  
        enable = true;  
        settings = {  
          signs = {  
            add.text = "┃";  
            change.text = "┃";  
            delete.text = "▁";  
            topdelete.text = "▔";  
            changedelete.text = "~";  
            untracked.text = "┆";  
          };  
           
          current_line_blame = true;  
          current_line_blame_opts = {  
            virt_text = true;  
            virt_text_pos = "eol";  
            delay = 1000;  
          };  
          
          # Diff configuration  
          diff_algorithm = "myers";  
          
          # Attachment behavior  
          auto_attach = true;  
          attach_to_untracked = true;  
          update_debounce = 100;  
        };
      };

      telescope = {
        enable = true;
	      keymaps = {
          "<leader><leader>" = "find_files";
	        "<leader>fg" = "live_grep";  
          "<leader>fb" = "buffers";  
          "<leader>fh" = "help_tags";
	      };
				extensions = {
					ui-select.enable = true;
					zf-native.enable = true;
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

      lsp-format = {
        enable = true;
	      lspServersToEnable = "all";
      };

      lsp_lines.enable = true;

      treesitter = {  
        enable = true;  
        nixGrammars = true;  
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [  
          bash  
          lua  
          markdown  
          nix
          markdown_inline  
          rust  
          vim  
          vimdoc  
          yaml
          cpp
          c-sharp
          html
          css
          javascript
        ];  
        settings = {  
          highlight = {  
            enable = true;  
          };  
          indent = { enable = true; };  
          incremental_selection = {  
            enable = true;  
            keymaps = {  
              init_selection = "gnn";  
              node_incremental = "grn";  
              scope_incremental = "grc";  
              node_decremental = "grm";  
            };  
          };  
        };  
      };
      nvim-tree = {  
        enable = true;  
        autoClose = true;  
        settings = {  
          disable_netrw = true;  
          hijack_netrw = false;  
          update_focused_file = {  
            enable = true;  
            update_root = false;  
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

      dashboard = {
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

			zen-mode = {
				enable = true;

				settings = {
					window = {
						backdrop = 0.95;
						height = 1;
						width = 120;

						options = {
							signcolumn = "no";
							number = false;
						};
					};

					plugins = {
						gitsigns.enabled = false;
						kitty.enabled = true;

						options = {
							enabled = true;
							ruler = false;
							showcmd = true;
						};
					};
				};

				refactoring = {
					enable = true;
					enableTelescope = true;

					settings = {
						prompt_func_param_type = {
							cpp = true;
							c = true;
					  	java = true;
							cxx = true;
							hpp = true;
							h = true;
						};
						show_success_message = true;
					};
				};
			};
    }; 

    dependencies = {  
      git.enable = true;  
      ripgrep.enable = true;  
      fd.enable = true;  
    };  

    opts = {
      # Numbers
      number = true;
      relativenumber = true;
      wrap = false;
      cursorline = true;
      signcolumn = "yes";
      scrolloff = 21;
      sidescrolloff = 20;

      # Search 
      ignorecase = true;
      smartcase = true;
      incsearch = true;
      hlsearch = true;

      clipboard = "unnamedplus";

      # Tab/Shift
      shiftwidth = 2;
      tabstop = 2;

      # Swap
      swapfile = false;
      backup = false;
      writebackup = false;
      undofile = true;

      # Fold
      foldmethod = "indent";
      foldlevel = 99;
      foldenable = false;

      timeoutlen = 500;
      completeopt = "menuone,noselect";
      updatetime = 250;

      splitbelow = true;
      splitright = true;
    };

    keymaps = [
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

		diagnostic.settings = {
			virtual_text = false;
			virtual_lines.only_current_line = true;
			plugins.lsp-lines.enable = true;
		};

		plugins.actions-preview.enable = true;  
  	plugins.lsp.keymaps.extra = [  
    	{  
      	key = "<leader>ca";  
      	action.__raw = "require('actions-preview').code_actions";  
      	options = { desc = "LSP code actions (actions-preview)"; };  
    	}  
			#{  
			#	key = "<leader>cA";  
			#	action.__raw = "require('telescope.builtin').code_actions";  
			# 	options.desc = "LSP code actions (all in buffer)";  
			#}  
  	];
  };
}
