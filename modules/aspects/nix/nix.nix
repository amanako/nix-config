{ inputs, ... }:

{
  flake-file.inputs = {
    hydra-check.url = "github:nix-community/hydra-check";
    cachix.url = "github:cachix/cachix";
  };

  den.aspects.nix =
    { user, ... }:
    {
      nixos = {
        nix.settings = {
          # Number of logical cores to use in parallel
          # "auto" will use all available
          max-jobs = "auto";
          cores = 0;
          http-connections = 50;

          trusted-users = [ user.userName ];

          extra-substituters = [
            "https://nix-community.cachix.org"
            "https://niri.cachix.org"
            "https://yazi.cachix.org"
            "https://noctalia.cachix.org"
            # nix cachyos kernels
            "https://attic.xuyh0120.win/lantian"
            "https://helix.cachix.org"

            # cache for this repo
            "https://amanako.cachix.org"
          ];
          # Official nix cache is already included
          extra-trusted-public-keys = [
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
            "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
            "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
            "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
            "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="

            # cache for this repo
            "amanako.cachix.org-1:sYWzosQAXLkVVLsWjl/36EJy5UqYHyvs5ztnKX2mmmY="
          ];
        };

        nix.gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 7d";
        };
        nix.settings.auto-optimise-store = true;
      };

      homeManager =
        { pkgs, ... }:
        let
          # Allows querying hydra for the build status of a package
          hydraCheckPackage = inputs.hydra-check.packages.${pkgs.stdenv.hostPlatform.system}.default;
        in
        {
          programs.nh = {
            enable = true;
            clean.enable = true;
            clean.extraArgs = "--keep 10 --keep-since 5d";
          };

          home.packages = [
            pkgs.cachix
            hydraCheckPackage
          ];
        };
    };
}
