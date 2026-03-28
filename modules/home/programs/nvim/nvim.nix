{
  den.aspects.development._.neovim = {
    nixos = {
      programs.neovim = {
        enable = true;
        viAlias = true;
      };
    };

    homeManager =
      { config, ... }:
      {
        programs.neovim.waylandSupport = true;
        xdg.configFile."nvim".source =
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/modules/home/programs/nvim/nvim";
      };
  };
}
