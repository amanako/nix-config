{
  inputs,
  lib,
  ...
}: let
  variants = [
    "bore"
    "latest"
    "bmq"
    "lts"
    "hardened"
    "deckify"
    "rt-bore"
    "server"
    "rc"
    "eevdf"
  ];
  uarchs = ["generic" "x86_64-v2" "x86_64-v3" "x86_64-v4" "zen4"];
in {
  flake-file = {
    inputs.nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    nixConfig = {
      extra-substituters = ["https://attic.xuyh0120.win/lantian"];
      extra-trusted-public-keys = ["lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="];
    };
  };

  den.aspects.core.nix-cachyos-kernel = {
    description = "CachyOS Linux kernel with various scheduler and optimization variants.";

    hostSettings = {
      variant = lib.mkOption {
        type = lib.types.enum variants;
        default = "bore";
        description = ''
          Kernel scheduler/variant.
          See https://github.com/xddxdd/nix-cachyos-kernel for details.
        '';
      };

      lto = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Clang+ThinLTO compilation.";
      };

      uarch = lib.mkOption {
        type = lib.types.enum uarchs;
        default = "generic";
        description = ''
          CPU microarchitecture optimization target.
        '';
      };
    };

    nixos = {
      host,
      pkgs,
      ...
    }: let
      cfg = host.settings.core.nix-cachyos-kernel;
      pkgName =
        "cachyos-${cfg.variant}"
        + lib.optionalString cfg.lto "-lto"
        + lib.optionalString (cfg.uarch != "generic") "-${cfg.uarch}";
    in {
      nixpkgs.overlays = [
        inputs.nix-cachyos-kernel.overlays.pinned
      ];

      boot.kernelPackages = pkgs.cachyosKernels."linuxPackages-${pkgName}";
    };
  };
}
