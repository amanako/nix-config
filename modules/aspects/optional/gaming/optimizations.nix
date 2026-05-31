{inputs, ...}: {
  flake-file = {
    inputs.nix-gaming.url = "github:fufexan/nix-gaming";

    nixConfig = {
      extra-substituters = ["https://nix-gaming.cachix.org"];
      extra-trusted-public-keys = [
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
    };
  };

  den.aspects.gaming.optimizations = {
    description = ''
      Small optimizations from selected sources aimed at gamers,
      or people who would like to improve their gaming and system experience.
    '';

    nixos = {
      imports = with inputs.nix-gaming.nixosModules; [
        platformOptimizations
        pipewireLowLatency
      ];

      services.pipewire.lowLatency.enable = true;
      # Make pipewire realtime-capable
      security.rtkit.enable = true;
    };
  };
}
