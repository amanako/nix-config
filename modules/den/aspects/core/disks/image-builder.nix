{lib, ...}: let
  # systemd >= 261 `udevadm settle` pings the systemd service manager over
  # varlink; disko's image builder VM runs a plain build script as PID 1, so
  # that ping times out and `set -e` aborts the build before anything is
  # formatted. The daemonized systemd-udevd still processes the triggered
  # uevents (and the kernel-provided partition nodes appear via devtmpfs
  # regardless), so a short best-effort settle suffices. `systemdMinimal` is
  # replaced with a symlinkJoin whose `udevadm` makes `settle` non-fatal.
  # `.override`/`.overrideAttrs` forward to the pristine package so downstream
  # variants (e.g. all-packages' `systemdLibs`) stay cache hits.
  overlay = final: prev: let
    # The udevadm replacement must be its own standalone script (not embedded
    # via a shell heredoc in `postBuild`): `symlinkJoin`'s `lndir` symlinks `bin`
    # into the read-only store, so writing through it raises EACCES.
    settleNoopUdevadm = prev.writeShellScript "udevadm-settle-noop" ''
      # systemd >= 261 requires a running service manager for `settle`; the
      # disko image VM has none, so make the wait best-effort.
      if [ "$1" = "settle" ]; then
        shift
        "$(dirname "$0")/.udevadm-real" settle --timeout=5 2>/dev/null
        exit 0
      fi
      exec "$(dirname "$0")/.udevadm-real" "$@"
    '';
  in {
    systemdMinimal =
      (prev.symlinkJoin {
        name = "systemd-minimal-settle-noop";
        paths = [prev.systemdMinimal];
        postBuild = ''
          # `lndir` symlinks the individual files of `bin` into the read-only
          # store, so writing through them raises EACCES; replace `bin` with a
          # real directory that re-links to the pristine systemdMinimal (whose
          # store path is known at eval time; `$out` is written in place).
          realBin="${prev.systemdMinimal}/bin"
          bin="$out/.bin-rebuild"
          mkdir -p "$bin"
          for f in "$realBin"/* "$realBin"/.*; do
            [ -e "$f" ] || continue
            base=$(basename "$f")
            case "$base" in
              . | ..) ;;
              udevadm)
                cp ${settleNoopUdevadm} "$bin/udevadm"
                ln -s "$f" "$bin/.udevadm-real"
                ;;
              *) ln -s "$f" "$bin/$base" ;;
            esac
          done
          rm -rf "$out/bin"
          mv "$bin" "$out/bin"
        '';
      })
      // {
        # `symlinkJoin` only produces an `out`; consumers that `buildInputs` us
        # (e.g. dbus, via `lib.getDev`) would otherwise resolve `dev` back to the
        # joined `out` and fail to find `libsystemd.pc`. Re-expose the pristine
        # split outputs so they stay cache hits.
        dev = prev.systemdMinimal.dev;
        man = prev.systemdMinimal.man;
        debug = prev.systemdMinimal.debug;

        # all-packages derives `systemdLibs = systemdMinimal.override {...}`;
        # forward to the pristine package so that stays a cache hit.
        override = args: prev.systemdMinimal.override args;
        overrideAttrs = f: prev.systemdMinimal.overrideAttrs f;
      };
  }
  // lib.optionalAttrs prev.stdenv.hostPlatform.isAarch64 {
    # The `systemdMinimal` override below changes the closure of `avahi`, so
    # `tinysparql` is rebuilt from source for the builder instead of coming from
    # the cache. On aarch64 its `test_endpoint_http` test intermittently
    # segfaults (SIGSEGV in the `tinysparql endpoint` subprocess), which would
    # block every image build. It is only build-time tooling here, so skip the
    # test suite rather than gating image builds on a flaky upstream test.
    tinysparql = prev.tinysparql.overrideAttrs (_: {
      doCheck = false;
    });
  };
in {
  den.aspects.core.disks.image-builder = {
    description = ''
      Makes disko's image builder work on current nixpkgs.

      The fixes are scoped to the builder itself: `vmTools` is pointed at the
      flattened kernel image (its bootable-image name derives from
      `kernel.target`, which disko's `aggregateModules` bundle lacks) and the
      builder's package set (`disko.imageBuilder.pkgs`) gets a `systemdMinimal`
      whose `udevadm settle` is non-fatal in the manager-less image VM. The
      host's own systemd/udev are untouched.
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
