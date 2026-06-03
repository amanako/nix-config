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

  den.aspects.nix = {host}: {
    # Reduce build time by preserving git caches
    provides.to-users.persysUser.directories = [
      ".cache/nix"
    ];

    nixos.nix = {
      settings = {
        # Number of logical cores to use in parallel
        # "auto" will use all available
        max-jobs = "auto";
        # Based on quide from https://bmcgee.ie/posts/2023/12/til-how-to-optimise-substitutions-in-nix/
        max-substitution-jobs = 128;
        http-connections = 128;
        # Use all available cores
        cores = 0;

        trusted-users = [
          # All users present in "wheel" group
          "@wheel"
        ];

        auto-optimise-store = true;
      };
    };
  };
}
