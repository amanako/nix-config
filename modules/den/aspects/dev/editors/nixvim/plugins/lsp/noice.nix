{
  nixvim.plugins.noice = {
    hm.programs.nixvim = {
      keymaps = [
        {
          mode = "n";
          key = "<leader>nh";
          action = "<cmd>Noice history<cr>";
        }
        {
          mode = "n";
          key = "<leader>np";
          action = "<cmd>Noice pick<cr>";
        }
        {
          mode = "n";
          key = "<leader>ne";
          action = "<cmd>Noice errors<cr>";
        }
        {
          mode = "n";
          key = "<leader>nd";
          action = "<cmd>Noice dismiss<cr>";
        }
        {
          mode = [
            "n"
            "i"
            "s"
          ];
          key = "<c-f>";
          action.__raw = ''function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end'';
          options = {
            silent = true;
            expr = true;
          };
        }
        {
          mode = [
            "n"
            "i"
            "s"
          ];
          key = "<c-b>";
          action.__raw = ''function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end'';
          options = {
            silent = true;
            expr = true;
          };
        }
      ];

      plugins = {
        notify.enable = true;
        snacks = {
          enable = true;
          settings.picker.enabled = true;
        };

        noice = {
          enable = true;
          settings = {
            views = {
              hover = {
                winoptions = {
                  winblend = 0;
                };
                border = "rounded";
              };
            };
            lsp = {
              signature.enabled = true;
              override = {
                "vim.lsp.util.convert_input_to_markdown_lines" = true;
                "vim.lsp.util.stylize_markdown" = true;
              };
            };
            presets = {
              command_palette = true;
              long_message_to_split = true;
              bottom_search = false;
            };
            commands = {
              errors = {
                filter = {
                  error = true;
                };
                filter_opts = {
                  reverse = true;
                };
                opts = {
                  enter = true;
                  format = "details";
                };
                view = "popup";
              };
              history = {
                filter = {
                  any = [
                    {
                      event = "notify";
                    }
                    {
                      error = true;
                    }
                    {
                      warning = true;
                    }
                    {
                      event = "msg_show";
                      kind = [
                        ""
                      ];
                    }
                    {
                      event = "lsp";
                      kind = "message";
                    }
                  ];
                };
                opts = {
                  enter = true;
                  format = "details";
                };
                view = "split";
              };
              last = {
                filter = {
                  any = [
                    {
                      event = "notify";
                    }
                    {
                      error = true;
                    }
                    {
                      warning = true;
                    }
                    {
                      event = "msg_show";
                      kind = [
                        ""
                      ];
                    }
                    {
                      event = "lsp";
                      kind = "message";
                    }
                  ];
                };
                filter_opts.count = 1;
                opts = {
                  enter = true;
                  format = "details";
                };
                view = "popup";
              };
            };
          };
        };
      };
    };
  };
}
