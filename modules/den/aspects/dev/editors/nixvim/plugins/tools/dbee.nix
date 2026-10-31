{inputs, ...}: {
  flake-file.inputs.cmp-dbee = {
    url = "github:MattiasMTS/cmp-dbee";
    flake = false;
  };

  nixvim.plugins.dbee = {
    hm = {pkgs, ...}: {
      programs.nixvim = {
        plugins.dbee = {
          enable = true;
          package = pkgs.vimPlugins.nvim-dbee;
          settings = {
            sources = [
              {__raw = ''require("dbee.sources").EnvSource:new("DBEE_CONNECTIONS")'';}
              {
                __raw = ''
                  require("dbee.sources").FileSource:new(
                    vim.fn.stdpath("state") .. "/dbee/persistence.json"
                  )
                '';
              }
            ];

            editor.mappings = [
              {
                key = "BB";
                mode = "v";
                action = "run_selection";
              }
              {
                key = "BB";
                mode = "n";
                action = "run_file";
              }
            ];
          };
        };

        extraPlugins = [
          pkgs.vimPlugins.nui-nvim
          (pkgs.vimUtils.buildVimPlugin {
            pname = "cmp-dbee";
            version = inputs.cmp-dbee.shortRev or inputs.cmp-dbee.rev or "unstable";
            src = inputs.cmp-dbee;
            doCheck = false;
          })
        ];

        extraConfigLua = ''
          require("cmp-dbee").setup({})
        '';

        keymaps = [
          {
            mode = "n";
            key = "<leader>db";
            action.__raw = ''function() require("dbee").toggle() end'';
            options.desc = "Toggle DBee";
          }
        ];

        plugins.blink-compat = {
          enable = true;
          settings.impersonate_nvim_cmp = true;
        };

        plugins.blink-cmp = {
          settings = {
            keymap = {
              preset = "default";
              "<CR>" = ["accept" "fallback"];
            };

            sources = {
              default = ["lsp" "path" "buffer"];

              per_filetype.sql = ["dbee" "buffer"];

              providers.dbee = {
                name = "cmp-dbee";
                module = "blink.compat.source";
                score_offset = 100;
              };
            };
          };
        };
      };
    };
  };
}
