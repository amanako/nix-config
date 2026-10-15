{
  den,
  inputs,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
in {
  flake-file.inputs.disko.url = "github:nix-community/disko";

  den.aspects.core.disks.disko = {
    description = ''
      Community tool for declarative disk partitioning on nixos.

      Actual partitioning happens when running script accessible as package
      $HOSTNAME.disko of repository, runnable via `just disko`.

      Also enables disko's image builder, so `.#<host>-image` (`just image
      <host>`) produces a bootable raw disk image carrying this host's disko
      layout. The builder VM runs as `aarch64-linux`/`x86_64-linux` matching
      the host; build it on matching hardware (or via a remote builder).
    '';

    includes = [
      den.aspects.core.disks.disko-collector
      den.aspects.core.disks.image-builder
      den.aspects.core.disks.esp
    ];

    hostSettings = {
      imageName = mkOption {
        type = types.str;
        default = "main";
        example = "nixos";
        description = "Base name of the generated raw disk image file (e.g. `main.raw`).";
      };

      imageSize = mkOption {
        type = types.str;
        default = "44G";
        example = "32G";
        description = ''
          Size of the generated raw disk image, as passed to `qemu-img create`.
          The main partition fills the whole image, so this must fit the host's
          store closure (see `nix path-info -Sh
          .#nixosConfigurations.<host>.config.system.build.toplevel`) plus the
          swapfile baked in by `swap-subvol` (`swapSize`) plus the ESP.
          The file is sparse until populated, so an over-generous size only
          costs real space while building. Downsize per host to keep images
          lean, e.g.:

          ```nix
          core.disks.disko.imageSize = "24G";
          ```
        '';
      };
    };

    nixos = {host, ...}: let
      cfg = host.settings.core.disks.disko;
    in {
      imports = [
        inputs.disko.nixosModules.disko
      ];

      disko.devices.disk.main = {
        imageName = lib.mkDefault cfg.imageName;
        imageSize = lib.mkDefault cfg.imageSize;
      };
    };
  };
}
