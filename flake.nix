# This file was auto-generated using flake-file.
# Run `just fw` if just is installed or `nix run .#write-flake` to revalidate it.
# It should NOT be edited manually, unless you have mistyped an input(branch name for example).
# If that is the case edit that typo here to point to valid link, then run the command above.
{
  description = "Adorable flake.";

  outputs = inputs: inputs.flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ./modules);

  nixConfig = {
    abort-on-warn = false;
    accept-flake-config = true;
    auto-optimise-store = true;
    extra-deprecated-features = ["or-as-identifier"];
    extra-experimental-features = ["pipe-operators" "pipe-operator"];
    extra-substituters = ["https://nix-community.cachix.org" "https://fzakaria.cachix.org" "https://vic.cachix.org" "https://attic.xuyh0120.win/lantian" "https://nix-gaming.cachix.org" "https://nyx-cache.chaotic.cx" "https://vicinae.cachix.org" "https://noctalia.cachix.org" "https://noctalia.cachix.org" "https://niri.cachix.org" "https://yazi.cachix.org" "https://cache.numtide.com" "https://amanako.cachix.org"];
    extra-trusted-public-keys = ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" "fzakaria.cachix.org-1:qWCiyGu0EmmRlo65Ro7b+L/QB0clhdeEofPxTOkRNng=" "vic.cachix.org-1:1fQNG1DxLTGd47MBAtr/IrUYIk+TTXDojOItpqFoxII=" "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" "nyx-cache.chaotic.cx:dJxTrgMC3V3cFfyIiBQDQorG6k1LsqurH/srpMSq7qk=" "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc=" "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964=" "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k=" "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" "amanako.cachix.org-1:sYWzosQAXLkVVLsWjl/36EJy5UqYHyvs5ztnKX2mmmY="];
  };

  inputs = {
    ascii-art = {
      url = "gitlab:ntgn/ascii-art";
      flake = false;
    };
    chaotic.url = "github:chaotic-cx/nyx/main";
    den.url = "github:denful/den";
    direnv-instant.url = "github:Mic92/direnv-instant";
    disko.url = "github:nix-community/disko";
    dms.url = "github:AvengeMedia/DankMaterialShell/stable";
    dms-plugin-registry.url = "github:AvengeMedia/dms-plugin-registry";
    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    flake-file.url = "github:denful/flake-file";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    flatpaks.url = "github:in-a-dil-emma/declarative-flatpak/latest";
    home-manager.url = "github:nix-community/home-manager";
    impermanence.url = "github:nix-community/impermanence";
    import-tree.url = "github:vic/import-tree";
    llm-agents.url = "github:numtide/llm-agents.nix";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    niri.url = "github:sodiboo/niri-flake/very-refactor";
    niri-pkgs.url = "github:sodiboo/niri-flake?rev=6bb99ff875919f03ea6054026619d999061e1170";
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
    noctalia.url = "github:noctalia-dev/noctalia/cachix";
    noctalia-shell.url = "github:noctalia-dev/noctalia/f816591afc2f2f606d1f0cf70b51e95c04a7a8aa";
    sops-nix.url = "github:Mic92/sops-nix";
    stylix.url = "github:nix-community/stylix";
    systems.url = "github:nix-systems/default-linux";
    vicinae.url = "github:vicinaehq/vicinae";
    vicinae-extensions.url = "github:vicinaehq/extensions";
    wallpapers = {
      url = "git+https://codeberg.org/voidptrx/wallpapers";
      flake = false;
    };
    yazi.url = "github:sxyazi/yazi";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };
}
