{
  nixvim.plugins.conform = {
    homeManager = {
      pkgs,
      lib,
      ...
    }: {
      programs.nixvim.plugins.conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            lua = ["stylua"];
            bash = [
              "shellcheck"
              "shellharden"
              "shfmt"
            ];
            c = ["clang_format"];
            cpp = ["clang_format"];
            nix = ["alejandra"];
            javascript = {
              __unkeyed-1 = "prettierd";
              __unkeyed-2 = "prettier";
              stop_after_first = true;
            };
            just = ["just-formatter"];
            "*" = ["codespell"];
            "_" = [
              "trim_whitespace"
              "trim_newlines"
            ];
          };

          log_level = "warn";
          notify_on_error = false;
          notify_no_formatters = false;
          formatters = {
            stylua.command = lib.getExe pkgs.stylua;
            shellcheck.command = lib.getExe pkgs.shellcheck;
            shfmt.command = lib.getExe pkgs.shfmt;
            shellharden.command = lib.getExe pkgs.shellharden;
            prettierd.command = lib.getExe pkgs.prettierd;
            prettier.command = lib.getExe pkgs.prettier;
            alejandra.command = lib.getExe pkgs.alejandra;
            codespell.command = lib.getExe pkgs.codespell;
            just-formatter.command = lib.getExe pkgs.just-formatter;
          };

          default_format_opts = {
            lsp_fallback = "never";
          };

          format_after_save = ''
            { async = true }, function(err, did_edit)
              -- called after formatting
            end
          '';
        };
      };
    };
  };
}
