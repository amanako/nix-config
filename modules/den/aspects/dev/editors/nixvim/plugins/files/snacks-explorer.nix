{
  nixvim.plugins.snacks-explorer = {
    hm.programs.nixvim = {
      keymaps = [
        {
          mode = "n";
          key = "<leader>e";
          action.__raw = "function() Snacks.explorer() end";
          options.desc = "Explorer";
        }
      ];

      plugins.snacks.settings.explorer = {
        enable = true;
        replace_netrw = true;
      };
    };
  };
}
