{inputs, ...}: {
  flake-file = {
    inputs.nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    nixConfig = {
      extra-substituters = ["https://attic.xuyh0120.win/lantian"];
      extra-trusted-public-keys = ["lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="];
    };
  };

  # Options for kernel can be viewed with `nix flake show github:xddxdd/nix-cachyos-kernel/release`
  den.aspects.core.nix-cachyos-kernel = {
    nixos = {
      lib,
      config,
      ...
    }: {
      config = {
        nixpkgs.overlays = [
          inputs.nix-cachyos-kernel.overlays.pinned
        ];

        warnings = let
          msg = ''
            `den.aspects.core.nix-cachyos-kernel` was included by host but none of the modules of kernel package host is using contain cachyos-related modules.
            This means host is likely not using provided cachyos kernels.
            If this is intended please remove aspect from host includes. If not, please enable one of the kernels
            with `pkgs.cachyosKernels.linuxPackages_''${name}. Reference: https://github.com/xddxdd/nix-cachyos-kernel.
          '';
          noCachyOsModule =
            builtins.all
            (module: !(lib.hasInfix "cachyos" module))
            (lib.attrNames config.boot.kernelPackages);
        in
          # Since warning fires when predicate is true and returns list return empty list and then append message to it
          (lib.warnIf
            noCachyOsModule
            msg [])
          ++ lib.optionals noCachyOsModule [msg];
      };
    };
  };
}
