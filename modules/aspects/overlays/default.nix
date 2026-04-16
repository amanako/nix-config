{ inputs, ... }:

{
  flake-file.inputs = {
    # Release version is guaranteed to have binary cache
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    yazi.url = "github:sxyazi/yazi";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    helix.url = "github:helix-editor/helix";
  };

  den.aspects.overlays =
    let
      overlays = with inputs; [
        nix-cachyos-kernel.overlays.pinned
        yazi.overlays.default
        neovim-nightly-overlay.overlays.default
        helix.overlays.helix
      ];
    in
    {
      nixos.nixpkgs.overlays = overlays;
      homeManager.nixkpgs.overlays = overlays;
    };
}
