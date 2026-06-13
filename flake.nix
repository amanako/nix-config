# This file was auto-generated using flake-file.
# It should NOT be edited manually.
# Run `nix run .#write-flake` to revalidate it.
{
  description = "Adorable flake";

  outputs = inputs: inputs.flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ./modules);

  nixConfig = {
    extra-substituters = ["https://nix-community.cachix.org" "https://fzakaria.cachix.org" "https://vic.cachix.org" "https://attic.xuyh0120.win/lantian" "https://nix-gaming.cachix.org" "https://nyx-cache.chaotic.cx" "https://noctalia.cachix.org" "https://niri.cachix.org" "https://amanako.cachix.org" "https://yazi.cachix.org"];
    extra-trusted-public-keys = ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" "fzakaria.cachix.org-1:qWCiyGu0EmmRlo65Ro7b+L/QB0clhdeEofPxTOkRNng=" "vic.cachix.org-1:1fQNG1DxLTGd47MBAtr/IrUYIk+TTXDojOItpqFoxII=" "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" "nyx-cache.chaotic.cx:dJxTrgMC3V3cFfyIiBQDQorG6k1LsqurH/srpMSq7qk=" "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964=" "amanako.cachix.org-1:sYWzosQAXLkVVLsWjl/36EJy5UqYHyvs5ztnKX2mmmY=" "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="];
  };

  inputs = {
    ascii-art = {
      url = "gitlab:ntgn/ascii-art";
      flake = false;
    };
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    den.url = "github:denful/den";
    disko.url = "github:nix-community/disko";
    dms.url = "github:AvengeMedia/DankMaterialShell/stable";
    dms-plugin-registry.url = "github:AvengeMedia/dms-plugin-registry";
    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    flake-file.url = "github:denful/flake-file";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    home-manager.url = "github:nix-community/home-manager";
    impermanence.url = "github:nix-community/impermanence";
    import-tree.url = "github:vic/import-tree";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    niri.url = "github:sodiboo/niri-flake/very-refactor";
    niri-pkgs.url = "github:sodiboo/niri-flake";
    nix-auto-follow = {
      url = "github:fzakaria/nix-auto-follow";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-monitor.url = "github:antonjah/nix-monitor";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
    noctalia.url = "github:noctalia-dev/noctalia-shell";
    stylix.url = "github:nix-community/stylix";
    systems.url = "github:nix-systems/default-linux";
    wallpapers = {
      url = "git+https://codeberg.org/voidptrx/wallpapers";
      flake = false;
    };
    yazi.url = "github:sxyazi/yazi";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };
}
