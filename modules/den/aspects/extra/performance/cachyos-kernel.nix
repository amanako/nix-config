{
  inputs,
  lib,
  ...
}: let
  inherit
    (lib)
    mkOption
    types
    ;
in {
  flake-file = {
    inputs.nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
  };

  den.aspects.extra.performance.cachyos-kernel = {
    description = "CachyOS Linux kernel with various scheduler and optimization variants.";

    hostSettings = let
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

      uarchs = [
        "generic"
        "x86_64-v2"
        "x86_64-v3"
        "x86_64-v4"
        "zen4"
      ];
    in {
      variant = mkOption {
        type = lib.types.enum variants;
        default = "bore";
        example = "rt-bore";
        description = ''
          Kernel scheduler/variant.
          See https://github.com/xddxdd/nix-cachyos-kernel for details.
        '';
      };

      lto = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Enable Clang+ThinLTO compilation.";
      };

      uarch = mkOption {
        type = types.enum uarchs;
        default = "generic";
        example = "zen4";
        description = "CPU microarchitecture optimization target.";
      };
    };

    nixos = {
      host,
      pkgs,
      ...
    }: let
      cfg = host.settings.extra.performance.cachyos-kernel;
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
