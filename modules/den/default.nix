{den, ...}: {
  den.default = {
    includes = [
      # Preprocessed inputs for host system
      den.batteries.inputs'
    ];

    persys = {
      hideMounts = true;
      directories = [
        # Without this dir all users/groups without specified
        # uids/gids will have them reassigned on reboot.
        "/var/lib/nixos"

        # Bluetooth device history
        "/var/lib/bluetooth"

        # Wifi connections
        "/etc/NetworkManager/system-connections"

        # Popup lecturing on sudo usage
        "/var/db/sudo/lectured"

        # Time stamps for systemd tasks
        "/var/lib/systemd/timers"
      ];

      files = [
        # Fix wpa/network errors
        "/etc/machine-id"
      ];
    };

    persysUser = {
      directories = [
        # Reduce buildtime by preserving git caches
        ".cache/nix"
      ];
    };

    nixos = {pkgs, ...}: {
      # Enable flakes and nix command
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      environment.systemPackages = with pkgs; [
        # For flakes to work properly
        git
      ];

      system.stateVersion = "25.11";

      home-manager.backupFileExtension = "backup";
    };

    homeManager = {
      # New behaviour since release 26.05
      gtk.gtk4.theme = null;

      home.stateVersion = "25.11";
    };
  };
}
