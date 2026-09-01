{
  lib,
  inputs,
  ...
}: {
  # Enable lock flattening: https://flake-file.denful.dev/guides/lock-flattening
  imports = [inputs.flake-file.flakeModules.nix-auto-follow];

  flake-file = {
    description = "Adorable flake.";
    do-not-edit = ''
      # This file was auto-generated using flake-file.
      # Run `just fw` if just is installed or `nix run .#write-flake` to revalidate it.
      # It should NOT be edited manually, unless you have mistyped an input(branch name for example).
      # If that is the case edit that typo here to point to valid link, then run the command above.
    '';

    formatter = pkgs: pkgs.alejandra;

    # When running nix flake check on even slightly outdated flake.lock dependencies error is thrown by hook check app.
    # Disable these checks to help with testing and debugging.
    check-hooks = lib.mkForce [];

    inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
      home-manager.url = "github:nix-community/home-manager";

      # Dependencies to flatten:
      # For flake-utils / noctalia-qs
      systems.url = "github:nix-systems/default-linux";
    };

    # Community cache used by various tools / cache for nix-auto-follow
    nixConfig = {
      extra-substituters = [
        "https://nix-community.cachix.org"
        "https://fzakaria.cachix.org"
        "https://nixos-raspberrypi.cachix.org"
      ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "fzakaria.cachix.org-1:qWCiyGu0EmmRlo65Ro7b+L/QB0clhdeEofPxTOkRNng="
        "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
      ];
    };
  };
}
