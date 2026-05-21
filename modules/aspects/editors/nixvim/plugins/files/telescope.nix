{
  nixvim.plugins.homeManager.programs.nixvim.plugins.telescope = {
    enable = true;
    keymaps = {
      "<leader><leader>" = "find_files";
      "<leader>fg" = "live_grep";
      "<leader>fb" = "buffers";
      "<leader>fh" = "help_tags";
    };
    extensions = {
      ui-select.enable = true;
      fzf-native.enable = true;
      media-files.enable = true;
      manix.enable = true;
      undo.enable = true;
      frecency.enable = true;
    };
  };
}
