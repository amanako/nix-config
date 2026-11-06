{
  nixvim.plugins.toggleterm = {
    hm = {user, ...}: let
      shell = user.settings.dev.shells.defaultShell;
    in {
      programs.nixvim = {
        keymaps = [
          {
            mode = "n";
            key = "<c-\\>";
            action = "<cmd>ToggleTerm<CR>";
            options = {
              desc = "Run ToggleTerm.";
            };
          }
        ];

        plugins.toggleterm = {
          enable = true;
          settings = {
            open_mapping = "[[<c-\\>]]";
            direction = "float";
            hide_numbers = false;
            autochdir = true;
            shell =
              if shell == "nushell"
              then "nu"
              else shell;

            float_opts = {
              border = "curved";
              winblend = 0;
            };
          };
        };
      };
    };
  };
}
