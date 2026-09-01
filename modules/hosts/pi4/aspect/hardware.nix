{den, ...}: {
  den.aspects.pi4.hardware = {
    includes = [
      den.aspects.core.hardware.raspberry-pi.common
    ];

    nixos = {pkgs, ...}: {
      networking = {
        hostName = "pi4";
        useDHCP = true;
      };

      # Use iwd for Wi-Fi (the kernel already has the iwlwifi firmware via nixos-raspberrypi)
      networking.wireless.enable = true;
      networking.networkmanager.enable = false;
      services.iwd.enable = true;

      # OpenSSH for remote management
      services.openssh = {
        enable = true;
        settings = {
          PermitRootLogin = "yes";
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
        };
      };

      # Disable graphical / display services
      services.xserver.enable = false;
      documentation.enable = false;

      # Reduce size: exclude docs and man pages from the build
      environment.enableAllProfiles = false;
      environment.defaultPackages = [
        pkgs.bash
        pkgs.coreutils
        pkgs.gnused
        pkgs.gnugrep
        pkgs.which
        pkgs.git
      ];
    };
  };
}
