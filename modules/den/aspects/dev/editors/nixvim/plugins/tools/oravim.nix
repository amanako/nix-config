{
  inputs,
  den,
  ...
}: {
  flake-file.inputs.oravim-nvim = {
    url = "github:KaravellasYiannis/oravim.nvim";
    flake = false;
  };

  nixvim.plugins.oravim = {
    includes = [
      (den.batteries.unfree [
        "oracle-instantclient"
        "sqlcl"
      ])
    ];

    hostConflicts.assertions = [
      ({host, ...}: [
        {
          subject = ["nixvim.plugins.oravim"];
          target = ["sqlcl"];
          assertion = host.system == "x86_64-linux";
          message = ''
            Host must be x86_64 machine for this plugin to work,
            since sqlcl is built for this arch.
          '';
        }
      ])
    ];

    hm = {
      pkgs,
      lib,
      ...
    }: let
      sqlplus = lib.getExe' pkgs.oracle-instantclient "sqlplus";
      sqlclLine = ''sqlcl = "${lib.getExe pkgs.sqlcl}",'';
    in {
      home.packages = with pkgs; [
        oracle-instantclient
        sqlcl
      ];

      programs.nixvim = {
        extraPlugins = [
          (pkgs.vimUtils.buildVimPlugin {
            pname = "oravim.nvim";
            version = inputs.oravim-nvim.shortRev or inputs.oravim-nvim.rev or "unstable";
            src = inputs.oravim-nvim;
            doCheck = false;
          })
        ];

        extraConfigLua = ''
          require("oravim").setup({
            cli = "${sqlplus}",
            ${sqlclLine}
            drawer = {
              width = 40,
              position = "left",
            },
            query = {
              filetype = "plsql",
              execute_on_save = true,
            },
          })
        '';

        keymaps = [
          {
            mode = "n";
            key = "<leader>do";
            action.__raw = ''function() require("oravim").toggle_ui() end'';
            options.desc = "Toggle Oravim";
          }
          {
            mode = "n";
            key = "<leader>dc";
            action.__raw = ''
              function()
                vim.ui.input({ prompt = "Oracle connection: " }, function(input)
                  if input and input ~= "" then
                    require("oravim").connect(input)
                  end
                end)
              end
            '';
            options.desc = "Connect to Oracle";
          }
        ];

        plugins.blink-cmp.settings.sources = {
          per_filetype = {
            sql = lib.mkAfter ["oravim"];
            plsql = ["oravim" "buffer"];
          };
          providers.oravim = {
            name = "oravim";
            module = "oravim.blink";
          };
        };
      };
    };
  };
}
