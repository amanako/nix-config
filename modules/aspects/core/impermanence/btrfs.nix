{
  # Script included for impermanence functionality on btrfs filesystems
  den.aspects.core.impermanence.btrfs = {host, ...}: let
    partition = "/dev/disk/by-id/${host.disko.devices.disk.main.device}-part-2";
  in {
    nixos = {
      pkgs,
      lib,
      ...
    }: {
      boot.initrd.systemd = {
        services.impermanence-btrfs-rolling-root = {
          description = "Archiving existing BTRFS root subvolume and creating a fresh one.";

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
