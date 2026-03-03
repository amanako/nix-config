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

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

		zen-browser = {
    	url = "github:0xc000022070/zen-browser-flake";
    	inputs = {
      	nixpkgs.follows = "nixpkgs";
      	home-manager.follows = "home-manager";
    	};
 	 	};

		firefox-addons = {
    	url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    	inputs.nixpkgs.follows = "nixpkgs";
  	};

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: 
  let
		username = "lunar-scar";
		term = "kitty";
		editor = "nvim";
		file-manager = "yazi";
		browser = "zen-beta";
		git = {
			name = "arcane-moonlight";
			email = "gitlab@kairi6.anonaddy.com";
		};
		in {
    nixosConfigurations = {
    nebula = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs username git; };
        modules = [
          ./nixos/configuration.nix

          home-manager.nixosModules.home-manager {
	    			home-manager.useUserPackages = true;
	    			home-manager.extraSpecialArgs = { inherit 
								inputs username
								term editor
								file-manager browser
								git; };
 
          	home-manager.users.lunar-scar = import ./home-manager/home.nix;
	 				}
				];
      };
    };
  };
}
