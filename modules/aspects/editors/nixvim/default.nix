{ inputs, ... }:

{
  flake-file.inputs = {
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.editors._.nixvim = {
    nixos = {

    };

    homeManager =
      { config, ... }:
      {
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
          ];

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
