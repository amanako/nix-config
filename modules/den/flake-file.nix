{ inputs, ... }:

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

    check-hooks = [
      {
        index = 2;
        program =
          pkgs:
          let
            autoFollowPkg = inputs.nix-auto-follow.packages.${pkgs.stdenv.hostPlatform.system}.default;
          in
          pkgs.writeShellApplication {
            name = "nix-auto-follow-check";
            runtimeInputs = [ autoFollowPkg ];
            text = ''
              auto-follow -c "$1"/flake.lock
            '';
          };
      }
    ];

    inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
      home-manager.url = "github:nix-community/home-manager";

      # Dependencies to flatten
      flake-compat.url = "github:edolstra/flake-compat";
      rust-overlay.url = "github:oxalica/rust-overlay";
      systems.url = "github:nix-systems/default";
      flake-utils.url = "github:numtide/flake-utils";
      git-hooks.url = "github:cachix/git-hooks.nix";
    };
  };
}
