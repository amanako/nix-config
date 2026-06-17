{inputs, ...}: {
  flake-file = {
    inputs.nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    nixConfig = {
      extra-substituters = ["https://attic.xuyh0120.win/lantian"];
      extra-trusted-public-keys = ["lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="];
    };
  };

  # After including aspect specify kernel with pkgs.cachyosKernels.linuxPackages_${name}
  # Options can be viewed with nix flake show github:xddxdd/nix-cachyos-kernel/release
  den.aspects.core.nix-cachyos-kernel = {
    nixos.nixpkgs.overlays = [
      inputs.nix-cachyos-kernel.overlays.pinned
    ];
  };
}
