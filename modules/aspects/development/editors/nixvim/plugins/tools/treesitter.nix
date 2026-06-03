{
  nixvim.plugins.treesitter = {user, ...}: {
    homeManager.programs.nixvim.plugins.treesitter = {
      enable = true;
      nixGrammars = true;

      settings = {
        highlight.enable = true;
        indent.enable = true;
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
  };
}
