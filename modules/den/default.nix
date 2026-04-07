{
  den.default.nixos =
    { pkgs, ... }:
    {
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
    };

  den.default.homeManager = {
    # New behaviour since release 26.05
    gtk.gtk4.theme = null;

    home.stateVersion = "25.11";
  };

  den.aspects.hjem.enable = false;
}
