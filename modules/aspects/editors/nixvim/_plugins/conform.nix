{
  pkgs,
  lib,
  ...
}: {
  plugins.conform-nvim = {
    enable = true;
    settings = {
      formatters_by_ft = {
        lua = ["stylua"];
        bash = [
          "shellcheck"
          "shellharden"
          "shfmt"
        ];
        cpp = ["clang_format"];
        nix = ["alejandra"];
        javascript = {
          __unkeyed-1 = "prettierd";
          __unkeyed-2 = "prettier";
          timeout_ms = 2000;
          stop_after_first = true;
        };
        "_" = [
          "trim_whitespace"
          "trim_newlines"
        ];
      };

      log_level = "warn";
      notify_on_error = false;
      notify_no_formatters = false;
      formatters = {
        stylua = {
          command = lib.getExe pkgs.stylua;
        };
        shellcheck = {
          command = lib.getExe pkgs.shellcheck;
        };
        shfmt = {
          command = lib.getExe pkgs.shfmt;
        };
        shellharden = {
          command = lib.getExe pkgs.shellharden;
        };
        prettier = {
          command = lib.getExe pkgs.prettier;
        };
        prettier-d = {
          command = lib.getExe pkgs.prettierd;
        };
        alejandra = {
          command = lib.getExe pkgs.alejandra;
        };
      };

      default_format_opts = {
        lsp_fallback = "never";
      };

      # Only format_after_save can be used asynchronously
      format_after_save = ''
        { async = true }, function(err, did_edit)
          -- called after formatting
        end
      '';
    };
  };
}
