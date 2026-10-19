{inputs, ...}: {
  imports = [(inputs.den.namespace "nixvim" false)];

  flake-file.inputs.nixvim.url = "github:nix-community/nixvim";

  nixvim.entry = {
    description = "A Neovim distribution built around Nix modules — configure Neovim with Nix.";

    persistUser.directories = [
      ".local/share/nvim"
      ".local/state/nvim"
    ];

    hm = {
      user,
      lib,
      config,
      ...
    }: {
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

      # The nixvim wrapper is the `nvim` users should get. `preferences-installer`
      # also installs a plain nixpkgs `neovim`, whose `bin/nvim` would otherwise
      # shadow it.
      home.packages = lib.mkBefore [
        (
          lib.hiPrio config.programs.nixvim.build.package
        )
      ];
    };
  };
}
