{ den, ... }:

{
  den.default = {
    nixos =
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
