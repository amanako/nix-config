{
  den.aspects.nix =
    { user, ... }:
    {
      nixos = {
        nix.settings = rec {
          # Number of logical cores to use in parallel
          # "auto" will use all available
          max-jobs = "auto";
          cores = 0;
          http-connections = 50;

          trusted-users = [ user.userName ];

          # Official, community and niri binary caches with their keys
          substituters = [
            "https://cache.nixos.org"
            "https://nix-community.cachix.org"
            "https://niri.cachix.org"
          ];
          trusted-substituters = substituters;
          trusted-public-keys = [
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
          ];
        };

        nix.gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 7d";
        };
        nix.settings.auto-optimise-store = true;
      };

      homeManager = {
        programs.nh = {
          enable = true;
          clean.enable = true;
          clean.extraArgs = "--keep 10 --keep-since 5d";
        };
      };
    };
}
