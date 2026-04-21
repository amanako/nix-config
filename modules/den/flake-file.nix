{
  flake-file = {
    description = "Adorable flake";

    inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
      den.url = "github:vic/den";
      flake-file.url = "github:vic/flake-file";
      flake-parts.url = "github:hercules-ci/flake-parts";

      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };
  };
}
