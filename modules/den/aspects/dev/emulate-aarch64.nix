{lib, ...}: {
  den.aspects.dev.emulate-aarch64 = {
    description = ''
      Emulate aarch64-linux binaries via binfmt_misc, so a host can build
      aarch64 packages and enter aarch64 chroots.
    '';

    hostSettings = {
      chrootSupport = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = ''
          Make the aarch64 emulator usable inside chroots and containers
          (nixos-install, nixos-enter, nspawn). Uses a static qemu and opens
          it at registration time. Turn off on hosts that only build aarch64
          packages and never install into an aarch64 root, to avoid the
          extra emulator closure. Default by on for no surprises.
        '';
      };
    };

    nixos = {host, ...}: let
      cfg = host.settings.dev.emulate-aarch64;
    in
      lib.optionalAttrs (host.system != "aarch64-linux") {
        boot.binfmt = {
          emulatedSystems = ["aarch64-linux"];

          # Use a statically linked qemu as the handler. A dynamic one resolves its
          # store path inside the chroot, where it doesn't exist, so the first
          # target binary fails with a misleading "No such file".
          preferStaticEmulators = cfg.chrootSupport;

          # Open the interpreter at registration time (the F flag), so the kernel
          # doesn't look for it again from inside the chroot.
          registrations.aarch64-linux.fixBinary = cfg.chrootSupport;
        };
      };
  };
}
