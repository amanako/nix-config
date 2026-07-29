{lib, ...}: {
  den.aspects.core.disks.luks = {
    description = ''
      LUKS-encrypts the root partition, independent of its filesystem type
      (btrfs, ext4, zfs, ...). The collector wraps the partition named by
      `target` in a luks layer; for btrfs layouts the swap subvolume stays
      inside the encrypted volume. Unlock is either interactive (password
      prompt) or unattended via a keyfile baked into the initrd, optionally
      sourced from a sops-nix secret. Opt-in: include alongside the partition
      aspect it should wrap, e.g. `den.aspects.core.disks.root-btrfs`.
    '';

    hostSettings = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "cryptroot";
        description = "Name of the LUKS mapping, visible under /dev/mapper.";
      };

      target = lib.mkOption {
        type = lib.types.str;
        default = "root";
        description = "Name of the GPT partition whose content is wrapped in luks.";
      };

      allowDiscards = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Pass --allow-discards to cryptsetup to enable TRIM passthrough.";
      };

      keyFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/boot/keyfile";
        description = ''
          Path (inside the initrd) of the LUKS keyfile. When set, boot is
          unattended: the keyfile is copied into the initrd from
          `keyFileSecret` when set, otherwise from the same path on the running
          system. When null, unlock is interactive.
        '';
      };

      keyFileSize = lib.mkOption {
        type = lib.types.int;
        default = 4096;
        description = "Size in bytes of the LUKS keyfile.";
      };

      keyFileSecret = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "luks-keyfile";
        description = ''
          Name of a sops-nix secret providing the keyfile content. Requires the
          sops-host aspect and a matching `sops.secrets.<name>` declaration.
        '';
      };
    };

    diskoConfig = {host, ...}: let
      cfg = host.settings.core.disks.luks;
    in {
      luks = {
        type = "luks";
        inherit
          (cfg)
          name
          target
          ;
        settings =
          {
            inherit (cfg) allowDiscards;
          }
          |> lib.mergeAttrs (lib.optionalAttrs (cfg.keyFile != null) {
            inherit
              (cfg)
              keyFile
              keyFileSize
              ;
          });
      };
    };

    nixos = {
      host,
      config,
      lib,
      ...
    }: let
      cfg = host.settings.core.disks.luks;

      hasLuks =
        config.disko.devices.disk.main.content.partitions
        |> lib.attrValues
        |> lib.any (p: p.content.type or "" == "luks");
    in {
      assertions = [
        {
          assertion = hasLuks;
          message = ''
            core.disks.luks: the collector did not wrap the partition named
            `${cfg.target}` in luks. Include the luks aspect alongside a
            partition with that name (e.g. `den.aspects.core.disks.root-btrfs`
            for the default "root" target).
          '';
        }
      ];

      boot.initrd.secrets = lib.mkIf (cfg.keyFile != null) {
        ${cfg.keyFile} =
          if cfg.keyFileSecret != null
          then config.sops.secrets.${cfg.keyFileSecret}.path
          else cfg.keyFile;
      };
    };
  };
}
