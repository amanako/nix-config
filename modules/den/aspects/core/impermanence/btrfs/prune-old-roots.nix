{lib, ...}: {
  den.aspects.core.impermanence.btrfs.prune-old-roots = {
    description = ''
      Prunes old archived root subvolumes created by the btrfs rolling-root
      service (`core.impermanence.btrfs`).

      Runs on a systemd timer (weekly by default) and, unless disabled, shortly
      after every boot, so archived roots never grow unboundedly.
    '';

    hostSettings = {host, ...}: let
      cfg = host.settings.core.impermanence.btrfs.prune-old-roots;

      inherit
        (lib)
        mkOption
        types
        ;
    in {
      minKeep = mkOption {
        type =
          if cfg.maxKeep == null
          then types.ints.positive
          else types.ints.between 1 cfg.maxKeep;
        default = 3;
        example = 2;
        description = ''
          Minimum number of newest archived root subvolumes that are never deleted.
        '';
      };

      maxKeep = mkOption {
        type = types.nullOr types.ints.positive;
        default = 10;
        example = 5;
        description = ''
          Delete archived root subvolumes beyond this number of newest ones.
          Since the root subvolume holds `/home` unless it is mounted separately,
          every archive is a full copy of it.
          `null` disables the bound, which leaves `deleteOlderThanDays` in charge.
        '';
      };

      deleteOlderThanDays = mkOption {
        type = types.nullOr types.ints.positive;
        default = 7;
        example = 14;
        description = ''
          Delete archived root subvolumes that are older than this many days,
          even among the newest `maxKeep` ones. `null` keeps archives by count
          only. `minKeep` is never touched by this.
        '';
      };

      calendar = mkOption {
        type = types.str;
        default = "weekly";
        example = "daily";
        description = ''
          Systemd `OnCalendar` expression deciding when archived roots are pruned.
        '';
      };

      onBootDelay = mkOption {
        type = types.nullOr types.str;
        default = "30min";
        example = null;
        description = ''
          Time span after boot at which pruning also runs, so repeated reboots
          cannot outgrow the retention bounds between `calendar` invocations.
          `null` disables the post-boot run, leaving only `calendar`.
        '';
      };
    };

    nixos = {
      host,
      pkgs,
      lib,
      ...
    }: let
      cfg = host.settings.core.impermanence;
      pruneCfg = cfg.btrfs.prune-old-roots;

      oldRootsPath = "${cfg.persistenceDir}/old_roots";

      btrfs = lib.getExe' pkgs.btrfs-progs "btrfs";
      coreutils = name: lib.getExe' pkgs.coreutils name;
      find = lib.getExe' pkgs.findutils "find";
      findmnt = lib.getExe' pkgs.util-linux "findmnt";
    in {
      systemd.services.impermanence-prune-old-roots = {
        description = "Pruning old archived BTRFS root subvolumes.";

        serviceConfig = {
          Type = "oneshot";
          TimeoutStartSec = "10min";
          RequiresMountsFor = cfg.persistenceDir;
          StandardOutput = "journal";
          StandardError = "journal";
        };

        script = ''
          set -euo pipefail
          IFS=$'\n\t'

          max_keep=${
            if pruneCfg.maxKeep == null
            then ""
            else toString pruneCfg.maxKeep
          }
          min_keep=${toString pruneCfg.minKeep}
          delete_older_than_days=${
            if pruneCfg.deleteOlderThanDays == null
            then ""
            else toString pruneCfg.deleteOlderThanDays
          }

          log() { echo "[impermanence] $*"; }
          warn() { echo "[impermanence] warning: $*" >&2; }

          old_roots="${oldRootsPath}"
          if [[ ! -d $old_roots ]]; then
            log "no old root archives to prune."
            exit 0
          fi

          # Archives live in the persistent subvolume, which is mounted already,
          # so no raw device has to be mounted (and none can be touched by
          # mistake). `btrfs subvolume list` reports paths relative to the
          # top-level subvolume, so the position of the mounted subvolume within
          # that top level is needed to re-anchor them.
          # A filesystem without subvolumes reports `/`, leaving the archives
          # addressed by their plain path.
          top_level="$(${findmnt} -nno FSROOT --target "${cfg.persistenceDir}")"
          rel_root=''${top_level#/}
          if [[ -n $rel_root ]]; then
            rel_old_roots="$rel_root/old_roots"
          else
            rel_old_roots=old_roots
          fi

          # Deleting a subvolume that holds subvolumes fails, and the path of
          # a child always sorts after the path of its parent.
          delete_subvolume() {
            local target=$1
            local rel=$2
            local -a rel_children=()
            local line
            local -a fields
            local rel_child
            local child

            ${btrfs} subvolume show "$target" > /dev/null 2>&1 \
              || { warn "$target is not a btrfs subvolume, leaving it alone."; return 1; }

            while IFS= read -r line; do
              IFS=' ' read -r -a fields <<< "$line"
              # The header repeats the column names instead of an ID.
              [[ ''${fields[1]:-} =~ ^[0-9]+$ ]] || continue
              # `btrfs subvolume list` reports paths relative to the top level
              # subvolume, which is not mounted here.
              rel_children+=("''${fields[*]:8}")
            done < <(${btrfs} subvolume list -o "$target")

            while IFS= read -r rel_child; do
              # printf renders an empty array as a single empty line.
              [[ -n $rel_child ]] || continue
              child="$target/''${rel_child#"$rel"/}"
              delete_subvolume "$child" "$rel_child" || warn "could not delete $child."
            done < <(printf '%s\n' "''${rel_children[@]}" | ${coreutils "sort"} -r)

            ${btrfs} subvolume delete "$target"
          }

          now=$(${coreutils "date"} +%s)
          index=0

          # Newest first, so both the floor and the ceiling are positions.
          while IFS=' ' read -r -d "" mtime entry; do
            index=$((index + 1))

            # The newest archives are the fallback and stay whatever happens.
            if (( index <= min_keep )); then
              continue
            fi

            prune=0
            if (( max_keep > 0 && index > max_keep )); then
              prune=1
            fi
            if [[ -n $delete_older_than_days ]] && (( now - ''${mtime%.*} >= delete_older_than_days * 86400 )); then
              prune=1
            fi

            if (( prune == 0 )); then
              continue
            fi

            log "pruning $entry."
            delete_subvolume "$entry" "$rel_old_roots/$(${coreutils "basename"} "$entry")" \
              || warn "could not delete $entry, it has to be removed by hand."
          done < <(${find} "$old_roots" -mindepth 1 -maxdepth 1 -printf '%T@ %p\0' | ${coreutils "sort"} -z -rn)
        '';
      };

      systemd.timers.impermanence-prune-old-roots = {
        wantedBy = ["timers.target"];

        timerConfig =
          {
            OnCalendar = pruneCfg.calendar;
            Persistent = true;
            RandomizedDelaySec = "15min";
          }
          // lib.optionalAttrs (pruneCfg.onBootDelay != null) {
            OnBootSec = pruneCfg.onBootDelay;
          };
      };
    };
  };
}
