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
    inputs.nixos-raspberrypi = {
      url = "github:nvmd/nixos-raspberrypi";

      # Keep upstream's own nixpkgs pin (nixos-26.05). Its binary cache is
      # built against that exact rev; following our unstable `nixpkgs`
      # changes the kernel config/build inputs, so every lookup misses and
      # the aarch64 kernel is compiled locally. `nix-auto-follow` is told to
      # ignore this input (see entry-point/flake-file.nix) so the pin sticks.
    };

    nixConfig = {
      extra-substituters = ["https://nixos-raspberrypi.cachix.org"];
      extra-trusted-public-keys = ["nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="];
    };
  };

  den.aspects.core.hardware.raspberry-pi = {
    description = ''
      Raspberry Pi board support using the `nixos-raspberrypi` flake.
      Provides the kernel, firmware, device trees and bootloader for the
      supported boards (Pi 02, 3, 4, 5). See `board` setting to pick one.

      Reference: https://github.com/nvmd/nixos-raspberrypi
    '';

    hostSettings = {
      board = mkOption {
        type = types.enum [
          "raspberry-pi-02"
          "raspberry-pi-3"
          "raspberry-pi-4"
          "raspberry-pi-5"
        ];
        example = "raspberry-pi-4";
        description = ''
          Raspberry Pi board model to enable support for. Setting this also
          pulls in the matching base kernel/firmware/bootloader modules from
          `nixos-raspberrypi`.
        '';
      };

      enableVc4 = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = ''
          Enable the VC4 graphics driver (Pi 4 only). Required for the official
          Pi 7" display or any KMS-based display output on Pi 4. Has no effect
          on Pi 5 (which uses the RP1 display driver instead).
        '';
      };
    };

    nixos = {
      config,
      ...
    }: {
      # The upstream `nixos-raspberrypi` board modules (e.g.
      # `nixosModules.raspberry-pi-4.base`) declare `nixos-raspberrypi` as a
      # module argument. The upstream README mandates passing it via
      # `specialArgs` when consuming the modules with `nixpkgs.lib.nixosSystem`
      # directly (see upstream #144 / #156 / discussion #73).
      #
      # den owns `nixosConfigurations` construction and its `specialArgs`, so we
      # can't use `nixos-raspberrypi.lib.nixosSystem` (which would sidestep den's
      # host/aspect machinery and inject extra cache/overlay defaults). Injecting
      # via `_module.args` is the den-compatible way to satisfy that contract.
      _module.args.nixos-raspberrypi = inputs.nixos-raspberrypi;

      imports = [
        # Overlays: bring in vendor + RPi-optimized packages and inject the
        # `pkgs.rpi` namespace into the global scope.
        inputs.nixos-raspberrypi.lib.inject-overlays
        # Trust the upstream RPi binary cache so we don't rebuild the kernel.
        inputs.nixos-raspberrypi.nixosModules.trusted-nix-caches
      ];

      nixpkgs.overlays = [
        (final: prev: {
          # The Pi kernel (and its external ZFS module) are built by
          # nixos-raspberrypi's own nixpkgs pin (26.05), whose kernel modules
          # predate the `modules.cer` file that the 26.11 kmod aggregator
          # unconditionally copies when assembling module trees (the NixOS
          # `system.modulesTree` and disko's image-builder VM). Assemble those
          # trees with the matching 26.05 aggregator instead.
          aggregateModules =
            inputs.nixos-raspberrypi.legacyPackages.${final.stdenv.hostPlatform.system}.aggregateModules;
        })
      ];

      # The `nixos-raspberrypi` package set stays on upstream's pinned
      # `nixpkgs` (26.05) to match its binary cache, but that kernel predates
      # the `kernel.target` attribute that our 26.11 module system reads for
      # this option's default. Use the 26.05-era filename (`Image` on the
      # aarch64 boards) instead of forcing a kernel rebuild.
      system.boot.loader.kernelFile = lib.mkForce (config.boot.kernelPackages.kernel.target or "Image");
    };
  };
}
