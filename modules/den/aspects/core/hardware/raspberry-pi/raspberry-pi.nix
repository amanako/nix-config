{
  inputs,
  lib,
  ...
}: {
  # Keep nixos-raspberrypi's nixpkgs following OUR unstable nixpkgs. This makes
  # its kernel build against the same nixpkgs as the surrounding config, so the
  # NixOS modules (device-tree, top-level, kernel) all agree on kernel attrs
  # like `buildDTBs` / `target`. Using the flake's OWN pinned nixos-26.05 nixpkgs
  # instead would serve a prebuilt kernel from its Cachix cache, BUT the 26.05
  # kernel lacks `buildDTBs`/`target` under our unstable module system, breaking
  # evaluation. So we accept a local QEMU-emulated kernel build (a one-time cost,
  # cached afterwards) in exchange for a clean eval.
  flake-file.inputs.nixos-raspberrypi = {
    url = "github:nvmd/nixos-raspberrypi";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.core.hardware.raspberry-pi = let
    inherit
      (lib)
      mkOption
      types
      ;
  in {
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

      enableUsbGadget = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = ''
          Enable USB Gadget/Ethernet so the Pi advertises itself as an
          Ethernet device over its USB-C port. Handy for headless setup on
          Pi Zero / Pi 4 / Pi 5.
        '';
      };
    };

    nixos = {
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
    };
  };
}
