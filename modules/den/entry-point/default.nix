{den, ...}: {
  den.default = {
    includes = [
      # Preprocessed inputs for host system
      den.batteries.inputs'
    ];

    nixos = {pkgs, ...}: {
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];

      environment.systemPackages = with pkgs; [
        git
      ];

      system.stateVersion = "25.11";
    };

    hm = {
      home.stateVersion = "25.11";
    };
  };
}
