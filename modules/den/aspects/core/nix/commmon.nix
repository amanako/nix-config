{
  flake-file.nixConfig = {
    extra-substituters = [
      "https://amanako.cachix.org"
      "http://kintoru.tail729600.ts.net:5000"
    ];

    extra-trusted-public-keys = [
      "amanako.cachix.org-1:sYWzosQAXLkVVLsWjl/36EJy5UqYHyvs5ztnKX2mmmY="
      "amanako-self:Wohj/CUvvZZbmUXYuFEeT+Sjnpk/1BolmF6Y3IgykyA="
    ];

    abort-on-warn = false;
    auto-optimise-store = true;
    accept-flake-config = true;

    extra-experimental-features = [
      "pipe-operators" # For nix
      "pipe-operator" # For lix
    ];
  };

  den.aspects.core.nix.common = {
    description = ''
      Highly recommended general-purpose nix settings.
    '';

    # Reduce build time by preserving git caches
    provides.to-users.persistUser.directories = [
      ".cache/nix"
    ];

    nixos.nix.settings = {
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
    };
  };
}
