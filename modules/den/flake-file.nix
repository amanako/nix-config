{
  flake-file = {
    description = "Adorable flake";
    do-not-edit = ''
      # This file was auto-generated using flake-file.
      # It should NOT be edited manually.
      # Run `nix run .#write-flake` to revalidate it.
    '';

    formatter = pkgs: pkgs.alejandra;

    inputs = {
      flake-file.url = "github:vic/flake-file";

      nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };
  };
}
