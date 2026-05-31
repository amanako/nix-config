{inputs, ...}: {
  flake-file = {
    # Release version is guaranteed to have binary cache
    inputs.nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    nixConfig = {
      extra-substituters = ["https://attic.xuyh0120.win/lantian"];
      extra-trusted-public-keys = ["lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="];
    };
  };

  den.aspects.performance.cachyos-kernel = {
    nixos.nixpkgs.overlays = [
      inputs.nix-cachyos-kernel.overlays.pinned
    ];
  };
}
