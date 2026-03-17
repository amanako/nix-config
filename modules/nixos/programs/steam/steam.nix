{ inputs, ... }:

{
  flake.modules.nixos.steam =
    { pkgs, ... }:
    {
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
}
