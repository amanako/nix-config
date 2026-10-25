{lib, ...}: let
  # systemd >= 261 `udevadm settle` pings the systemd service manager over
  # varlink; disko's image builder VM runs a plain build script as PID 1, so
  # that ping times out and `set -e` aborts the build before anything is
  # formatted. The daemonized systemd-udevd still processes the triggered
  # uevents (and the kernel-provided partition nodes appear via devtmpfs
  # regardless), so a short best-effort settle suffices.
  #
  # Overriding `systemdMinimal` itself changes the hash of every package in the
  # builder closure that depends on it, forcing a from-source rebuild of ~90
  # packages and defeating the binary cache. Instead, prepend a tiny `udevadm`
  # shim to the builder VM's PATH: it only intercepts `settle` and delegates
  # everything else to the pristine `udevadm`.
  overlay = final: prev: let
    settleNoopUdevadm = prev.writeShellScriptBin "udevadm" ''
      if [ "$1" = "settle" ]; then
        shift
        ${prev.systemdMinimal}/bin/udevadm settle --timeout=5 2>/dev/null || true
        exit 0
      fi
      exec ${prev.systemdMinimal}/bin/udevadm "$@"
    '';
  in {
    vmTools = lib.makeOverridable (args: let
      baseVmTools = prev.vmTools.override args;
    in
      baseVmTools
      // {
        runInLinuxVM = drv:
          baseVmTools.runInLinuxVM (drv.overrideAttrs (old: {
            buildInputs = [settleNoopUdevadm] ++ (old.buildInputs or []);
          }));
      }) {};
  };
in {
  den.aspects.core.disks.image-builder = {
    description = ''
      Makes disko's image builder work on current nixpkgs.

      The fixes are scoped to the builder itself: `vmTools` is pointed at the
      flattened kernel image (its bootable-image name derives from
      `kernel.target`, which disko's `aggregateModules` bundle lacks) and a
      small `udevadm` shim is prepended to the builder VM's PATH so that
      `udevadm settle` is non-fatal in the manager-less image VM. The host's
      own systemd/udev are untouched, and the builder closure stays a binary
      cache hit.
    '';

    nixos = {pkgs, ...}: let
      # The builder VM runs on the build platform. For a cross host (e.g. the
      # Raspberry Pi) use the build platform's packages so the VM boots natively
      # and only the target arch is emulated via binfmt.
      base =
        if pkgs.stdenv.hostPlatform == pkgs.stdenv.buildPlatform
        then pkgs
        else pkgs.buildPackages;
    in {
      nixpkgs.overlays = [
        (final: prev: {
          vmTools = prev.vmTools.override {
            kernelImage =
              if prev.stdenv.hostPlatform.isAarch64
              then "Image"
              else "bzImage";
          };
        })
      ];

      disko.imageBuilder.pkgs = lib.mkDefault (base.extend overlay);
    };
  };
}
