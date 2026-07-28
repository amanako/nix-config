{
  lib,
  inputs,
  ...
}: {
  imports = [(inputs.den.namespace "nixvim" false)];

  flake-file.inputs.nixvim.url = "github:nix-community/nixvim";

  nixvim.entry = {
    description = "A Neovim distribution built around Nix modules — configure Neovim with Nix.";

    persistUser.directories = [
      ".local/share/nvim"
      ".local/state/nvim"
    ];

    nushellConfig = {user, ...}:
      lib.optionalString (user.preferences.editor == "nvim") ''
        $env.EDITOR = "nvim"
      '';

    stylixHMSettings.targets."nixvim".enable = false;

    hm = {user, ...}: {
      imports = [inputs.nixvim.homeModules.nixvim];

      programs.nixvim = {
        enable = true;
        nixpkgs.source = inputs.nixpkgs;

        waylandSupport = true;
        defaultEditor = user.preferences.editor == "nvim";
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
        wrapRc = true;

        globals.mapleader = " ";
      };
    };
  };
}
