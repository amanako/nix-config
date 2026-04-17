{ den, ... }:

{
  den.aspects.nebula._.hardware =
    { host, ... }:
    {
      includes = [
        den.aspects.hardware
        den.aspects.hardware._.with-disko
        den.aspects.hardware._.with-impermanence
      ];

      nixos =
        {
          pkgs,
          lib,
          # modulesPath,
          ...
        }:
        let
          # Recommended to use by-id instead of label or uuid because it's more reliable
          deviceID = "nvme-SAMSUNG_MZVLQ512HBLU-00B00_S6F5NS0T325504";
          device = "/dev/disk/by-id/${deviceID}";
          partition = "${device}-part2";
        in
        {
          # Without adding this modulesPath AMD and bluetooth service fail to start
          # With message hardware initialization failed
          # EDIT: After adding facter.json report below it seems OK to remove this line
          # imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
          imports = [ ./_disko.nix ];
          hardware.facter.reportPath = ./facter.json;

          boot.initrd.availableKernelModules = [
            "nvme"
            "xhci_pci"
          ];

          boot.kernelPackages = lib.mkDefault pkgs.cachyosKernels.linuxPackages-cachyos-lts-lto-zen4;

          boot.kernelModules = [
            "kvm-amd"
            "btrfs"
          ];

          boot.kernelParams = [
            "video=DP-1:1920x1080@144"
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

          #services.udev.extraRules = ''
          # /etc/udev/rules.d/99-no-watchdog.rules
          #SUBSYSTEM=="char", KERNEL=="watchdog*", OPTIONS+="ignore_remove"
          #'';

          boot.supportedFilesystems = [
            "btrfs"
            "ext4"
            "fat"
            "vfat"
            "exfat"
          ];

          fileSystems."/persist".neededForBoot = true;

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
              requiredBy = [ "initrd.target" ];
              # Should complete before any file systems are mounted
              before = [ "sysroot.mount" ];

              # Wait until the root device is available
              # If you're altering a different device, specify its device unit explicitly.
              # see: systemd-escape(1)
              requires = [ "initrd-root-device.target" ];
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

                max_age=30 #days 
                for i in $(find /btrfs_tmp/persist/old_roots/ -mindepth 1 -maxdepth 1 -mtime $max_age); do
                  delete_subvolume_recursively "$i"
                done

                echo "Cleaned root."

                btrfs subvolume create /btrfs_tmp/root

                umount /btrfs_tmp
                echo "Created fresh root."
              '';
            };

            extraBin = {
              "mkdir" = "${pkgs.coreutils}/bin/mkdir";
              "date" = "${pkgs.coreutils}/bin/date";
              "mv" = "${pkgs.coreutils}/bin/mv";
              "find" = "${pkgs.findutils}/bin/find";
              "btrfs" = "${pkgs.btrfs-progs}/bin/btrfs";
              # mount & umount already exist
            };
          };

          boot.loader.limine = {
            resolution = "1920x1080x32";
            style = {
              interface = {
                resolution = "1920x1080";
                branding = "Paranoia";
                brandingColor = 3;
              };
              wallpaperStyle = "stretched";
              wallpapers = [
                (pkgs.fetchurl {
                  url = "https://pic1.cdncl.net/game/user_upload/hssaole/36d351cc7ab10fadfb1953704de2b5d4.jpeg";
                  hash = "sha256-si07feEPfDcxfTUGrL7ThVRtp8pHxwtrff+DLOXqZpM=";
                })
              ];
            };
          };

          environment.persistence."/persist" = {
            hideMounts = true;
            directories = [
              # Without this dir all users/groups without specified
              # uids/gids will have them reassigned on reboot.
              "/var/lib/nixos"
              # Preserve bluetooth device history
              "/var/lib/bluetooth"
            ];

            files = [
              # Fix wpa/network errors
              "/etc/machine-id"
            ];
            users.lunar-scar = {
              directories = [
                "Dev"
                "Documents"
                "Downloads"
                "Faks"
                "nix-config" # Main config
                "Pictures"
                {
                  directory = ".ssh";
                  mode = "0600";
                }
                {
                  directory = ".gnupg";
                  mode = "0600";
                }

                ".config/zen/*"

                ".local/share/nvim"
                ".local/state/nvim"

                ".local/share/Steam"
                ".local/share/lutris/runners"
                ".local/share/youtube-tui"

                ".local/share/zoxide" # zoxide database
              ];
              files = [
                ".bash_history" # bash history
                ".local/share/fish/fish_history" # fish history
              ];
            };
          };
        };
    };
}
