{ den, inputs, ... }:

{
  den.aspects.nebula._.hardware = {
    includes = [
      den.aspects.hardware
      den.aspects.hardware._.with-disko
      den.aspects.hardware._.with-impermanence
    ];

    nixos =
      {
        pkgs,
        lib,
        modulesPath,
        ...
      }:
      let
        # diskoConfig = import ./_disko.nix;
        btrfs = lib.getExe pkgs.btrfs-progs;
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

        # I like to use zen packages buy it may be changed
        # Using _latest is likely to overflow the /boot
        boot.kernelPackages = pkgs.linuxPackages_zen;

        boot.kernelModules = [
          "kvm-amd"
          "btrfs"
        ];

        boot.supportedFilesystems = [
          "btrfs"
          "ext4"
          "fat"
          "vfat"
          "exfat"
        ];

        fileSystems."/persist".neededForBoot = true;

        boot.initrd.postResumeCommands = lib.mkAfter ''
          mkdir /btrfs_tmp
            mount ${partition} /btrfs_tmp
            if [[ -e /btrfs_tmp/root ]]; then
              mkdir -p /btrfs_tmp/persist/old_roots
              timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
	      mv /btrfs_tmp/root "/btrfs_tmp/persist/old_roots/$timestamp"
	      echo "Created backup at /btrfs_tmp/persist/old_roots with timestamp $timestamp."
            fi

            delete_subvolume_recursively() {
              IFS=$'\n'
              for i in $(${btrfs} subvolume list -o "$1" | cut -f 9- -d ' '); do
                delete_subvolume_recursively "/btrfs_tmp/$i"
              done
              ${btrfs} subvolume delete "$1"
            }

            max_age = 30 #days 
            for i in $(find /btrfs_tmp/persistent/old_roots/ -mindepth 1 -maxdepth 1 -mtime +$max_age); do
              delete_subvolume_recursively "$i"
            done
	    echo "Cleaned root."

            ${btrfs} subvolume create /btrfs_tmp/root
            umount /btrfs_tmp
	    echo "Created fresh root."
        '';

        environment.persistence."/persist" = {
          hideMounts = true;
          directories = [
            "/var/lib/nixos"
            "/var/lib/bluetooth"
          ];
          files = [
            # Fix network and wpa... errors
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
                mode = "0700";
              }
            ];
            files = [
            ];
          };
        };
      };
  };
}
