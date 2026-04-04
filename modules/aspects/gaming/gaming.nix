{
  den.aspects.gaming = {
    nixos =
      { pkgs, ... }:
      {
        programs.gamemode = {
          enable = true;
          enableRenice = true;
        };

        programs.steam = {
          enable = true;
          gamescopeSession.enable = true;
          fontPackages = with pkgs; [
            biz-ud-gothic
            hanazono
          ];
          extraPackages = with pkgs; [
            gamescope
            gamescope-wsi
          ];
        };
      };
  };
}
