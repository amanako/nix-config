{
  lib,
  inputs,
  ...
}: let
  # Keep each Nixpkgs input paired with the Home Manager release tested
  # against it. The generated Home Manager input follows its paired Nixpkgs.
  nixpkgsChannels = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
      homeManagerBranch = "master";
    };
    nixpkgs-stable = {
      url = "github:NixOS/nixpkgs/nixos-26.05";
      homeManagerBranch = "release-26.05";
    };
  };

  nixpkgsInputs = lib.mapAttrs (_: channel: {inherit (channel) url;}) nixpkgsChannels;

  homeManagerInputs =
    lib.genAttrs (builtins.attrNames nixpkgsChannels) (nixpkgsInput: {
      url = "github:nix-community/home-manager/${nixpkgsChannels.${nixpkgsInput}.homeManagerBranch}";
      inputs.nixpkgs.follows = nixpkgsInput;
    })
    |> lib.mapAttrs' (nixpkgsInput: value: {
      name = lib.replaceStrings ["nixpkgs"] ["home-manager"] nixpkgsInput;
      inherit value;
    });
in {
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

    prune-lock.program = pkgs:
      pkgs.writeShellApplication {
        name = "nix-auto-follow";
        runtimeInputs = [inputs.nix-auto-follow.packages.${pkgs.stdenv.hostPlatform.system}.default];
        text = ''
          auto-follow --ignore nix-cachyos-kernel --ignore nixos-raspberrypi "$1" > "$2"
        '';
      };

    formatter = pkgs: pkgs.alejandra;

    # When running nix flake check on even slightly outdated flake.lock dependencies error is thrown by hook check app.
    # Disable these checks to help with testing and debugging.
    check-hooks = lib.mkForce [];

    inputs =
      nixpkgsInputs
      // homeManagerInputs
      // {
        # Dependencies to flatten:
        # For flake-utils / noctalia-qs
        systems.url = "github:nix-systems/default-linux";
      };

    # Community cache used by various tools / cache for nix-auto-follow
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
