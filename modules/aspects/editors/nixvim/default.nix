{inputs, ...}: {
  flake-file = {
    inputs = {
      nixvim.url = "github:nix-community/nixvim";
    };
  };

  den.aspects.editors.provides.nixvim = {
    persysUser = {
      directories = [
        ".local/share/nvim"
        ".local/state/nvim"
      ];
    };

    homeManager = {
      config,
      pkgs,
      lib,
      ...
    }: {
      imports = [
        inputs.nixvim.homeModules.nixvim
      ];

      xdg.dataFile."applications/nvim.desktop".text = ''
        [Desktop Entry]
        Name=Neovim
        Exec=${config.home.sessionVariables.TERM} -e nvim
        Terminal=false
        Type=Application
        Keywords=Text;editor;
        Icon=nvim
        Categories=Utility;TextEditor;
        StartupNotify=false
      '';

      programs.nixvim = {
        imports = [
          ./_colorschemes
          ./_dependencies
          ./_keymaps
          ./_opts
          ./_extraConfig
          ./_plugins
          {inherit pkgs lib;}
        ];

        plugins.treesitter = {
          enable = true;
          nixGrammars = true;
          grammarPackages = with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
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

        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
        wrapRc = true;

        globals = {
          mapleader = " ";
        };
      };
    };
  };
}
