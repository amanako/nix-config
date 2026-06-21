{den, ...}: {
  den.default = {
    includes = [
      # Preprocessed inputs for host system
      den.batteries.inputs'
    ];

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
