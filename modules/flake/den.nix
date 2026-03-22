{ inputs, ... }:

{
  imports = [ inputs.den.flakeModule ];

  den.default.nixos =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        nix-settings
      ];
      # Flakes are superiour to channels so they won't be needed
      nix.channel.enable = false;

      # Add user to be able to use some nix-settings features
      # E.g. Use cache from substituters
      nix.settings.trusted-users = [ "lunar-scar" ];

      # Enable flakes and new nix command
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      environment.systemPackages = with pkgs; [
        # For flakes to work properly
        git
        # Text editor to use
        neovim
      ];

      system.stateVersion = "25.11";
    };

  den.default.homeManager.home.stateVersion = "25.11";
}
