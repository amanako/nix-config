{
  description = "A basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: 
  let
    inherit (self) outputs;
  in {
    nixosConfigurations = {
      nebula = nixpkgs.lib.nixosSystem {
        specialArgs = { 
	  inherit
	    inputs
	    outputs
	    ;
	};
        modules = [
          ./nixos/configuration.nix

          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
	    home-manager.useUserPackages = true;

	    home-manager.users.lunar-scar = import ./home-manager/home.nix;
	  }
	];
      };
    };
  };
}
