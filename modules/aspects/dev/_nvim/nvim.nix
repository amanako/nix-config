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
      let
        currentDir = "${config.home.homeDirectory}/nix-config/modules/aspects/dev/_nvim";
      in
      {
        programs.neovim.waylandSupport = true;
        xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/nvim";
      };
  };
}
