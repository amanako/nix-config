{inputs, ...}: {
  flake-file = {
    # Release version is guaranteed to have binary cache
    inputs = {
      nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
      neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    };

    nixConfig = {
      extra-substituters = ["https://attic.xuyh0120.win/lantian"];
      extra-trusted-public-keys = ["lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="];
    };
  };

  den.aspects.overlays = let
    overlays = with inputs; [
      nix-cachyos-kernel.overlays.pinned
      yazi.overlays.default
      neovim-nightly-overlay.overlays.default
      helix.overlays.helix
    ];
  in {
    nixos.nixpkgs.overlays = overlays;
    homeManager.nixpkgs.overlays = overlays;
  };
}
