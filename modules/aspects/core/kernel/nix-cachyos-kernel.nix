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
          # ----------------------------------------------------------------------
          # The warning text that will be shown when no CachyOS kernel module is present
          # ----------------------------------------------------------------------
          msg = ''
            `den.aspects.core.nix-cachyos-kernel` was included by host but none of the
            modules of the kernel package that host is using contain CachyOS‑related
            modules.
            This means the host is likely not using the provided CachyOS kernels.
            If this is intended, please remove the aspect from host includes.
            If not, enable one of the kernels with
            `pkgs.cachyosKernels.linuxPackages_''${name}`.
            Reference: https://github.com/xddxdd/nix-cachyos-kernel.
          '';

          # ----------------------------------------------------------------------
          # Boolean: true when **no** attribute name of `config.boot.kernelPackages`
          # contains the substring “cachyos”.
          # ----------------------------------------------------------------------
          noCachyOsModule =
            config.boot.kernelPackages
            |> lib.attrNames
            |> builtins.all (mod: !(mod |> lib.hasInfix "cachyos"));
        in
          # `lib.warnIf` prints the warning as a side‑effect when the predicate is true.
          # It returns its third argument unchanged, so we give it an empty list `[]`.
          # `lib.optional` adds the message to the list only when the predicate is true.
          lib.warnIf noCachyOsModule msg [] ++ lib.optional noCachyOsModule msg;
      };
    };
  };
}
