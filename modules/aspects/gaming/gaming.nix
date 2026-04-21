{
  den.aspects.gaming = {
    persysUser = {
      directories = [
        ".local/share/Steam"
        ".local/share/lutris/runners"
      ];
    };

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

    homeManager = {
      programs.lutris = {
        enable = true;
      };
    };
  };
}
