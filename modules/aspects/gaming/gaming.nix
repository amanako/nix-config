{
  inputs,
  den,
  ...
}: {
  flake-file = {
    inputs.nix-gaming.url = "github:fufexan/nix-gaming";

    nixConfig = {
      extra-substituters = ["https://nix-gaming.cachix.org"];
      extra-trusted-public-keys = [
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
    };
  };

  den.aspects.gaming = {
    includes = [
      (den.batteries.unfree [
        "steam"
        "steam-unwrapped"
      ])
    ];

    persysUser.directories = [
      ".local/share/Steam"
    ];

    nixos = {
      pkgs,
      lib,
      config,
      ...
    }: {
      imports = with inputs.nix-gaming.nixosModules; [
        platformOptimizations
        pipewireLowLatency
      ];

      services.pipewire.lowLatency.enable = true;
      # Make pipewire realtime-capable
      security.rtkit.enable = true;

      programs.gamemode = {
        enable = true;
        enableRenice = true;
      };

      programs.gamescope = {
        enable = true;
        capSysNice = true;
      };

      programs.steam = {
        enable = true;
        protontricks.enable = true;
        platformOptimizations.enable = true;

        fontPackages = builtins.filter lib.types.package.check config.fonts.packages;

        extraPackages = with pkgs; [
          gamescope
          gamescope-wsi
        ];

        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
      };
    };
  };
}
