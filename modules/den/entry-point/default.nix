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

        # Popup lecturing on sudo usage
        "/var/db/sudo/lectured"

        # Time stamps for systemd tasks which should help with remembering timers countdown
        "/var/lib/systemd/timers"
      ];

      files = [
        # Fix wpa/network errors
        "/etc/machine-id"
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
    };

    homeManager = {
      home.stateVersion = "25.11";
    };
  };
}
