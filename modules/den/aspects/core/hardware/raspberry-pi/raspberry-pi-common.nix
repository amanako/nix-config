{
  den,
  inputs,
  ...
}: {
  den.aspects.core.hardware.raspberry-pi.common = {
    description = ''
      Common includes for a Raspberry Pi system: the base board module
      plus the SD-image fallback. Tune the board and display via
      `board`/`enableVc4` in the host entry. For a USB gadget Ethernet
      tether, include `core.hardware.usb-gadget-ether-device` separately.
    '';

    includes = [
      den.aspects.core.hardware.raspberry-pi
      den.aspects.core.hardware.raspberry-pi.sd-image
      # Sensible default on relatively low RAM devices.
      den.aspects.core.disks.zram
    ];

    nixos = {
      host,
      lib,
      config,
      ...
    }: let
      inherit
        (host.settings.core.hardware.raspberry-pi)
        board
        enableVc4
        ;
    in {
      # Fix clock issues on first boot.
      # Order other services suffering from clock misalignment after `time-sync.target`.
      systemd.services.wait-for-clock-sync = {
        description = "Wait until the system clock is synchronized";
        wantedBy = ["time-sync.target"];
        before = ["time-sync.target"];
        after = ["systemd-timesyncd.service"];
        wants = ["systemd-timesyncd.service"];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${config.systemd.package}/lib/systemd/systemd-time-wait-sync";
          TimeoutStartSec = "30s"; # don't hang boot forever if there's no network
        };
      };

      boot = {
        # kernelPackages comes from the upstream `raspberry-pi-*.base` module
        # default (nixos-raspberrypi's own linuxPackages_rpi4), which is
        # maintained. Do NOT override with nixpkgs' pkgs.linuxKernel.packages.
        # linux_rpi4 — that series is deprecated in nixpkgs (warns on
        # instantiation, slated for removal).

        initrd.availableKernelModules = [
          "xhci_pci"
          "usbhid"
          "usb_storage"
        ];
      };

      imports =
        [
          inputs.nixos-raspberrypi.nixosModules.${board}.base
        ]
        ++ lib.optional enableVc4 inputs.nixos-raspberrypi.nixosModules.raspberry-pi-4.display-vc4;

      # Firmware / config.txt overrides (Pi 4)
      hardware.raspberry-pi.config = {
        all = {
          dt-overlays.vc4-kms-v3d.enable = enableVc4;
        };
      };

      # Allow redistributable firmware (RPi bootloader / wifi firmware)
      hardware.enableRedistributableFirmware = true;

      # The Raspberry Pi needs its device trees installed to boot. Set this
      # explicitly to `true`: the upstream `nixos-raspberrypi` kernel is built
      # against nixos-26.05 and doesn't expose `buildDTBs` under our
      # nixos-unstable module system, so relying on the default
      # (`config.boot.kernelPackages.kernel.buildDTBs`) would fail to evaluate.
      hardware.deviceTree.enable = true;
    };
  };
}
