{
  den,
  inputs,
  ...
}: {
  den.aspects.core.hardware.raspberry-pi.common = {
    description = ''
      Common includes for a Raspberry Pi system.
      Includes the base board module plus optional VC4, USB-gadget
      and bluetooth configuration, then wires up the user-level
      pieces (openssh, iwd, wpa-supplicant, etc.).

      Override `board`, `enableVc4` and `enableUsbGadget` in the
      host entry to tune per-board.
    '';

    includes = [
      den.aspects.core.hardware.raspberry-pi
    ];

    nixos = {
      host,
      pkgs,
      lib,
      ...
    }: let
      inherit
        (host.settings.core.hardware.raspberry-pi)
        board
        enableVc4
        enableUsbGadget
        ;
    in {
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

        loader = {
          grub.enable = false;
          generic-extlinux-compatible.enable = true;
        };
      };

      imports =
        [
          inputs.nixos-raspberrypi.nixosModules.${board}.base
        ]
        ++ lib.optional enableVc4 inputs.nixos-raspberrypi.nixosModules.raspberry-pi-4.display-vc4
        ++ lib.optional enableUsbGadget inputs.nixos-raspberrypi.nixosModules.usb-gadget-ethernet;

      # Firmware / config.txt overrides (Pi 4)
      hardware.raspberry-pi.config = {
        all = {
          dt-overlays.vc4-kms-v3d.enable = enableVc4;
        };
      };

      # Networking: USB gadget ethernet when enabled, firewall, and
      # iwd + wpa-supplicant integration. Wi-Fi is configured per-SSID
      # in the host entry; this is the fallback wired-only profile.
      #networking =
      #lib.optionalAttrs enableUsbGadget {
      #usbGadgetEthernet = {
      #   address = "10.0.0.1";
      #    enableIpv6 = false;
      #  };
      #}
      #// {
      #  firewall.enable = true;
      #  wireless.iwd.enable = true;
      #};

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
