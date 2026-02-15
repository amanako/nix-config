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

    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: 
  let
  in {
    nixosConfigurations = {
      nebula = nixpkgs.lib.nixosSystem {
        specialArgs = { 
	  inherit
	    inputs
	    ;
	};
        modules = [
          ./nixos/configuration.nix
	  ./home-manager/niri.nix
	  ./home-manager/noctalia.nix

          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
	    home-manager.useUserPackages = true;
	    home-manager.extraSpecialArgs = { inherit inputs; };
 
            home-manager.users.lunar-scar = import ./home-manager/home.nix;
	 }
	];
      };
    };
  };
}
