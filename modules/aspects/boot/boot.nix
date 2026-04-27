{
  den.aspects.boot = {
    nixos = {pkgs, ...}: {
      stylix.targetsToDisable = ["plymouth"];

      boot.plymouth = {
        enable = true;
        theme = "nixos-bgrt";
        themePackages = [
          pkgs.nixos-bgrt-plymouth
        ];
      };

      boot = {
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
  };
}
