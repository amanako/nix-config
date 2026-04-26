{ inputs, lib, ... }:

{
  # Enable lock flattening: https://flake-file.oeiuwq.com/guides/lock-flattening/
  imports = [ inputs.flake-file.flakeModules.nix-auto-follow ];

  flake-file = {
    description = "Adorable flake";
    do-not-edit = ''
      # This file was auto-generated using flake-file.
      # It should NOT be edited manually.
      # Run `nix run .#write-flake` to revalidate it.
    '';

    formatter = pkgs: pkgs.alejandra;

    # TODO: Look at possible workarounds for not removing checks completely
    check-hooks = lib.mkForce [ ];

    inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
      home-manager.url = "github:nix-community/home-manager";

      # Dependencies to flatten:
      # For flake-utils / noctalia-qs
      systems.url = "github:nix-systems/default-linux";
      # For helix / yazi
      rust-overlay.url = "github:oxalica/rust-overlay";
    };

    # Community cache used by various tools
    nixConfig = {
      extra-substituters = [
        "https://nix-community.cachix.org"
        "https://fzakaria.cachix.org"
      ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "fzakaria.cachix.org-1:qWCiyGu0EmmRlo65Ro7b+L/QB0clhdeEofPxTOkRNng="
      ];
    };
  };
}
