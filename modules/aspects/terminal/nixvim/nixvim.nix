{ inputs, ... }:

{
  flake-file.inputs = {
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.terminal._.nixvim = {
    homeManager = {
      imports = [
        inputs.nixvim.homeModules.nixvim
      ];

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
