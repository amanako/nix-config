{
  # Cache for this repo
  flake-file = {
    inputs.determinate.url = "github:DeterminateSystems/nix-src";
    nixConfig = {
      extra-substituters = [
        "https://amanako.cachix.org"
        "https://install.determinate.systems"
      ];

      extra-trusted-public-keys = [
        "amanako.cachix.org-1:sYWzosQAXLkVVLsWjl/36EJy5UqYHyvs5ztnKX2mmmY="
        "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
      ];
    };
  };

  den.aspects.nix = {
    nixos = {inputs', ...}: {
      nix = {
        package = inputs'.determinate.packages.default;
        settings = {
          # Number of logical cores to use in parallel
          # "auto" will use all available
          max-jobs = "auto";
          # Based on quide from https://bmcgee.ie/posts/2023/12/til-how-to-optimise-substitutions-in-nix/
          max-substitution-jobs = 128;
          http-connections = 128;
          # Use all available cores
          cores = 0;

          # Features from determinate nix not present in vanilla version, should improve operations significantly
          lazy-trees = true;
          eval-cores = 0;

          trusted-users = [
            "@wheel"
          ];
        };

        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 7d";
        };
        settings.auto-optimise-store = true;
      };
    };

    homeManager = {pkgs, ...}: {
      programs.nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep 10 --keep-since 5d";
      };

      home.packages = with pkgs; [
        cachix
      ];
    };
  };
}
