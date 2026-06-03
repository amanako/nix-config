{
  den.aspects.boot.optional.silence = {host}: {
    nixos.boot = {
      # Remove verbosity
      consoleLogLevel = 3;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "udev.log_level=3"
        "systemd.show_status=auto"
      ];
    };
  };
}
