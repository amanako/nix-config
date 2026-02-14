{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }@inputs: {
    nixosConfigurations.nebula= nixpkgs.lib.nixosSystem {
      modules = [
        ./nixos/configuration.nix
      ];
    };
  };
}
