{ inputs, ... }:

{
  imports = [ inputs.den.flakeModule ];

  den.default.nixos =
    { pkgs, ... }:
    {
      imports = [ ];
      home-manager.useGlobalPkgs = true;
      nix.settings.trusted-users = [ "lunar-scar" ];
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
