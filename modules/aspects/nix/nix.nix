{
  # Cache for this repo
  flake-file.nixConfig = {
    extra-substituters = [
      "https://amanako.cachix.org"
    ];

    extra-trusted-public-keys = [
      "amanako.cachix.org-1:sYWzosQAXLkVVLsWjl/36EJy5UqYHyvs5ztnKX2mmmY="
    ];
  };

  den.aspects.nix = {
    nixos = {
      nix.settings = {
        # Number of logical cores to use in parallel
        # "auto" will use all available
        max-jobs = "auto";
        cores = 0;
        http-connections = 50;

        trusted-users = [
          "@wheel"
        ];
      };

      nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
      nix.settings.auto-optimise-store = true;
    };

    homeManager = {pkgs, ...}: {
      programs.nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep 10 --keep-since 5d";
      };

      home.packages = with pkgs; [
        statix
        cachix
      ];
    };
  };
}
