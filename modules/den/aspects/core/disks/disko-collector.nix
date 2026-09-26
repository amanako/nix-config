{lib, ...}: let
  inherit
    (lib)
    mkOption
    types
    ;

  defaultMountOptions = [
    "compress=zstd"
    "noatime"
  ];

  applyDefaults = subvol:
    subvol
    |> lib.mergeAttrs (lib.optionalAttrs (!(subvol ? mountOptions)) {
      mountOptions = defaultMountOptions;
    });
in {
  den.aspects.core.disks.disko-collector = {
    description = ''
      Assembles all diskoConfig quirk contributions into the final disko.devices config.
    '';

    hostSettings = {
      devicePath = mkOption {
        type = types.str;
        example = "/dev/disk/by-id/ata-QEMU_HARDDISK_QM00001";
        description = "Path to disk device to be formatted.";
      };
    };

    nixos = {
      host,
      diskoConfig,
      ...
    }: let
      cfg = host.settings.core.disks.disko-collector;

      allParts =
        diskoConfig
        |> lib.map (item: item.partitions or {})
        |> lib.mergeAttrsList;

      allSubvols =
        diskoConfig
        |> lib.map (item: item.subvolumes or {})
        |> lib.mergeAttrsList;

      luksConfig =
        diskoConfig
        |> lib.map (item: item.luks or null)
        |> lib.findFirst (item: item != null) null;

      subvolumes =
        {
          "/root".mountpoint = "/";
          "/nix".mountpoint = "/nix";
        }
        |> lib.recursiveUpdate allSubvols
        |> lib.mapAttrs (_: applyDefaults);

      # Wrap the partition named by the luks contribution's `target` when the
      # luks aspect is included. Independent of the underlying filesystem type.
      wrapLuks = name: part:
        if luksConfig != null && name == luksConfig.target or "root"
        then
          part
          // {
            content =
              lib.removeAttrs luksConfig ["target"]
              // {
                content = part.content;
              };
          }
        else part;

      # Inject subvolumes into btrfs content. Non-btrfs content (ext4, zfs, ...)
      # is left untouched, so a luks-wrapped non-btrfs partition is safe.
      injectInto = content:
        if content.type or "" == "btrfs"
        then
          content
          // {
            inherit subvolumes;
          }
        else content;

      # Inject subvolumes into the btrfs content, seeing through the luks wrapper.
      injectSubvolumes = part:
        if part.content.type or "" == "btrfs"
        then
          part
          // {
            content = injectInto part.content;
          }
        else if part.content.type or "" == "luks"
        then
          part
          // {
            content =
              part.content
              // {
                content = injectInto part.content.content;
              };
          }
        else part;
    in {
      disko.devices.disk.main = {
        type = "disk";
        device = cfg.devicePath;
        content = {
          # GPT is defacto standard and is therefore prioritized over other legacy MBR tables.
          type = "gpt";
          partitions =
            allParts
            |> lib.mapAttrs (name: part: part |> wrapLuks name |> injectSubvolumes);
        };
      };
    };
  };
}
