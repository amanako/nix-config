{den, ...}: {
  den.aspects.nebula._.hardware = {host, ...}: {
    includes = [
      den.aspects.hardware
    ];

    nixos = {
      pkgs,
      lib,
      modulesPath,
      ...
    }: let
      # Recommended to use by-id instead of label or uuid because it's more reliable.
      deviceID = "nvme-SAMSUNG_MZVLQ512HBLU-00B00_S6F5NS0T325504";
      device = "/dev/disk/by-id/${deviceID}";
      partition = "${device}-part2";
    in {
      imports = [(modulesPath + "/installer/scan/not-detected.nix")];

      boot.initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
      ];

      boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-lts-lto-zen4;

      boot.kernelModules = [
        "kvm-amd"
        "btrfs"
      ];

      boot.kernelParams = [
        # The driver will attempt to reset the GPU and continue instead of requiring a full system reboot
        "amdgpu.gpu_recovery=1"
        # Enables GPU memory retry logic
        "amdgpu.noretry=0"
        # If the GPU doesn't respond within this time(in ms), the driver will trigger the recovery mechanism
        "amdgpu.lockup_timeout=10000"
        # Watchdogs usually slowdown shutdown
        "nowatchdog"
      ];

      boot.blacklistedKernelModules = [
        "iTCO_wdt"
        "intel_pmc_bxt"
        "iTCO_vendor_support"
        "softdog"
        "sp5100_tco"
      ];

      boot.supportedFilesystems = [
        "btrfs"
        "ext4"
        "fat"
        "vfat"
        "exfat"
      ];

      boot.initrd.systemd = {
        services.impermanence-btrfs-rolling-root = {
          description = "Archiving existing BTRFS root subvolume and creating a fresh one";

          # Specify dependencies explicitly
          unitConfig.DefaultDependencies = false;
          serviceConfig = {
            Type = "oneshot";
            # NOTE: to be able to see errors in your script do this
            StandardOutput = "journal+console";
            StandardError = "journal+console";
          };

          # This service is required for boot to succeed
          requiredBy = ["initrd.target"];
          # Should complete before any file systems are mounted
          before = ["sysroot.mount"];

          # Wait until the root device is available
          # If you're altering a different device, specify its device unit explicitly.
          # see: systemd-escape(1)
          requires = ["initrd-root-device.target"];
          after = [
            "initrd-root-device.target"
            # Allow hibernation to resume before trying to alter any data
            "local-fs-pre.target"
          ];

          script = ''
            mkdir /btrfs_tmp
            mount ${partition} /btrfs_tmp
            if [[ -e /btrfs_tmp/root ]]; then
              mkdir -p /btrfs_tmp/persist/old_roots
              timestamp=$(TZ=${host.timeZone} date "+%h-%d-%Y_%R")
              mv /btrfs_tmp/root "/btrfs_tmp/persist/old_roots/$timestamp"
              echo "Created backup at /btrfs_tmp/persist/old_roots with timestamp $timestamp."
            fi

            delete_subvolume_recursively() {
              IFS=$'\n'
              for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                delete_subvolume_recursively "/btrfs_tmp/$i"
              done
              btrfs subvolume delete "$1"
            }

            max_age=7 #days
            for i in $(find /btrfs_tmp/persist/old_roots/ -mindepth 1 -maxdepth 1 -mtime $max_age); do
              delete_subvolume_recursively "$i"
            done

            echo "Cleaned root."

            btrfs subvolume create /btrfs_tmp/root

            umount /btrfs_tmp
            echo "Created fresh root."
          '';
        };

        extraBin = let
          # The binary names that come from coreutils
          coreutils = [
            "mkdir"
            "date"
            "mv"
          ];

          other = {
            find = pkgs.findutils;
            btrfs = pkgs.btrfs-progs;
          };
        in
          lib.genAttrs coreutils (name: lib.getExe' pkgs.coreutils name)
          // lib.mapAttrs (name: pkg: lib.getExe' pkg name) other;
      };
    };
  };
}
