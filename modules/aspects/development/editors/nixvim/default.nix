{inputs, ...}: {
  imports = [(inputs.den.namespace "nixvim" false)];

  flake-file.inputs.nixvim.url = "github:nix-community/nixvim";

  nixvim.entry = {
    persistUser.directories = [
      ".local/share/nvim"
      ".local/state/nvim"
    ];

    stylixHMSettings.targets."nixvim".enable = false;

    hm = {
      imports = [inputs.nixvim.homeModules.nixvim];

      programs.nixvim = {
        enable = true;
        waylandSupport = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
        wrapRc = true;

        globals.mapleader = " ";
      };
    };
  };
}
