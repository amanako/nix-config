{lib, ...}: {
  den.aspects.core.impermanence.btrfs = {
    description = ''
      Script included for impermanence functionality on btrfs filesystems.

      The root subvolume is archived at every boot and replaced by a fresh one.
      Hibernation case handled via checking for efi variable, in which case roll is boot.
    '';

    hostSettings = {...}: let
      inherit
        (lib)
        mkOption
        types
        ;
    in {
      disk-partition = mkOption {
        type = types.str;
        example = "/dev/disk/by-id/ata-Samsung_SSD_870_EVO_1TB_ABC123";
        description = ''
          Full name of the partition to wipe on each reboot
          Can be found by looking at output `ls -l /dev/disk/by-id`.
        '';
      };
    };

    nixos = {
      config,
      host,
      pkgs,
      lib,
      ...
    }: let
      cfg = host.settings.core.impermanence;
      btrfsCfg = cfg.btrfs;

      subvolOf = mountPoint: let
        options = config.fileSystems.${mountPoint}.options or [];
        declared = lib.filter (option: lib.hasPrefix "subvol=" option) options;
      in
        lib.removePrefix "/" (
          if declared == []
          then mountPoint
          else lib.removePrefix "subvol=" (builtins.head declared)
        );

      mountPoint = "/btrfs_tmp";
      rootPath = "${mountPoint}/${subvolOf "/"}";
      nixPath = "${mountPoint}/${subvolOf "/nix"}";
      persistPath = "${mountPoint}/${subvolOf cfg.persistenceDir}";
      oldRootsPath = "${persistPath}/old_roots";

      tzDir = "${pkgs.tzdata}/share/zoneinfo";

      rollsRoot = subvolOf "/" != "";
    in {
      boot.initrd.systemd = {
        services.impermanence-btrfs-rolling-root = lib.mkIf rollsRoot {
          description = "Archiving existing BTRFS root subvolume and creating a fresh one.";

          unitConfig.DefaultDependencies = false;
          serviceConfig = {
            Type = "oneshot";
            TimeoutStartSec = "10min";
            StandardOutput = "journal+console";
            StandardError = "journal+console";
          };

          requiredBy = ["initrd.target"];
          before = [
            "sysroot.mount"
            "systemd-hibernate-resume.service"
          ];

          requires = ["initrd-root-device.target"];
          after = ["initrd-root-device.target"];

          script = ''
            set -euo pipefail
            IFS=$'\n\t'

            log() { echo "[impermanence] $*"; }
            warn() { echo "[impermanence] warning: $*" >&2; }
            die() { echo "[impermanence] error: $*" >&2; exit 1; }

            # Existence of this var indicates hibernation took place.
            # Combined with correct ordering before systemd-hibernate-resume.service which removes this var the check succeeds.
            # Credit: @aeiuo on Reddit
            efivars=/sys/firmware/efi/efivars
            hibernate_var="$efivars/HibernateLocation-8cf2644b-4b0b-428f-9387-6d876050dc67"

            if [[ -e "$hibernate_var" ]]; then
              log "HibernateLocation EFI variable exists – skipping root roll."
              exit 0
            fi

            mounted=0

            cleanup() {
              sync
              if [[ $mounted == 1 ]]; then
                umount -R "${mountPoint}" || warn "could not unmount ${mountPoint}."
              fi
              rmdir "${mountPoint}" 2> /dev/null || true
            }
            trap cleanup EXIT

            # A wrong `disk-partition` or a filesystem that does not hold this
            # host's subvolumes must never be treated as a normal boot: rolling
            # it would archive and delete somebody else's data. That is reported
            # and the boot continues with the root subvolume as it is, which
            # beats failing the boot over a wrong setting.
            if [[ ! -b "${btrfsCfg.disk-partition}" ]]; then
              warn "${btrfsCfg.disk-partition} is not a block device, keeping the root subvolume."
              exit 0
            fi

            mkdir -p "${mountPoint}"
            if ! mount "${btrfsCfg.disk-partition}" "${mountPoint}"; then
              warn "could not mount ${btrfsCfg.disk-partition}, keeping the root subvolume."
              exit 0
            fi
            mounted=1

            # A wrong `disk-partition` would archive someone else's subvolume
            # and later delete it, so refuse to touch a filesystem that does not
            # hold the subvolumes this host is built around.
            expected=1
            for required in "${nixPath}" "${persistPath}"; do
              if ! btrfs subvolume show "$required" > /dev/null 2>&1; then
                warn "${btrfsCfg.disk-partition} does not hold the subvolume $required, keeping the root subvolume."
                expected=0
              fi
            done
            (( expected == 1 )) || exit 0

            archive=

            if [[ -e "${rootPath}" ]]; then
              if ! btrfs subvolume show "${rootPath}" > /dev/null 2>&1; then
                warn "${rootPath} is not a btrfs subvolume, keeping it as it is."
                exit 0
              fi

              mkdir -p "${oldRootsPath}"

              stamp=$(TZDIR="${tzDir}" TZ="${host.settings.basic.time.timeZone}" LC_ALL=C date "+%b-%d-%Y_%R")
              archive="${oldRootsPath}/$stamp"
              attempt=1
              while [[ -e $archive ]]; do
                archive="${oldRootsPath}/$stamp-$attempt"
                attempt=$((attempt + 1))
              done

              # -T keeps a pre-existing directory from swallowing the root.
              if ! mv -T "${rootPath}" "$archive"; then
                warn "could not archive ${rootPath}, keeping the root subvolume."
                exit 0
              fi
              # Renaming keeps the mtime of the root, which says nothing about
              # when the archive was taken.
              touch "$archive"
              log "archived the previous root to $archive."
            else
              log "found no root subvolume, creating one."
            fi

            if ! btrfs subvolume create "${rootPath}"; then
              warn "could not create a fresh root subvolume."
              # Booting the previous root is stale but working, which is a much
              # better outcome than an emergency shell.
              if [[ -n ''${archive:-} ]]; then
                if mv -T "$archive" "${rootPath}"; then
                  log "restored the previous root subvolume, this boot is not rolled."
                  exit 0
                fi
                warn "could not restore the previous root, it is still at $archive."
                die "boot cannot continue without a root subvolume."
              fi
              die "there is no root subvolume and none could be created."
            fi

            btrfs filesystem sync "${mountPoint}" || warn "could not sync the filesystem."
            btrfs filesystem df "${mountPoint}" || warn "could not read the filesystem usage."
            log "created a fresh root subvolume."
          '';
        };

        # `date` resolves `TZ` through `TZDIR`, which the initrd does not set.
        storePaths = lib.mkIf rollsRoot [pkgs.tzdata];

        extraBin = lib.mkIf rollsRoot (
          let
            coreutilsBinNames = [
              "date"
              "mkdir"
              "mv"
              "rmdir"
              "sync"
              "touch"
            ];

            other = {
              btrfs = pkgs.btrfs-progs;
            };
          in
            coreutilsBinNames
            |> lib.flip lib.genAttrs (name: lib.getExe' pkgs.coreutils name)
            |> lib.flip lib.mergeAttrs (lib.mapAttrs (n: p: lib.getExe' p n) other)
        );
      };
    };
  };
}
