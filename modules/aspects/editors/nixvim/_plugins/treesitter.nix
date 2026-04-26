{ pkgs, ... }:

{
  plugins.treesitter = {
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
      hightlight.enable = true;
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
}
