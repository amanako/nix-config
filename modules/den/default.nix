{den, ...}: {
  den.default = {
    includes = [
      den._.inputs'
      # Using perHost avoids duplication.
      (den.lib.perHost (
        {
          host,
          lib,
        }:
        # TODO: Look into fix
          lib.optional host.wantsNvidiaSupport den.aspects.nvidia
      ))
    ];

    persys = {
      hideMounts = true;
      directories = [
        # Without this dir all users/groups without specified
        # uids/gids will have them reassigned on reboot.
        "/var/lib/nixos"
        # Preserve bluetooth device history
        "/var/lib/bluetooth"
      ];

      files = [
        # Fix wpa/network errors
        "/etc/machine-id"
      ];
    };

    nixos = {pkgs, ...}: {
      # Enable flakes and new nix command
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

    user = {
      includes = [
        den._.define-user
      ];
    };
  };
}
