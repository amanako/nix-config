{den, ...}: {
  den.aspects.gaming.software = {
    description = ''
      Handpicked software used to leverage gaming experience.
    '';

    includes = [
      (den.batteries.unfree [
        "steam"
        "steam-unwrapped"
      ])

      den.aspects.gaming.chaotic-integration
    ];

    persistUser.directories = [
      ".local/share/Steam"
    ];

    nixos = {
      user,
      pkgs,
      lib,
      config,
      ...
    }: {
      programs = {
        gamemode = {
          enable = true;
          enableRenice = true;
        };

        gamescope = {
          enable = true;
          capSysNice = true;
        };

        steam = {
          enable = true;
          protontricks.enable = true;
          platformOptimizations.enable = true;

          fontPackages = builtins.filter lib.types.package.check config.fonts.packages;

          extraPackages = with pkgs; [
            gamescope
            gamescope-wsi
          ];

          extraCompatPackages = let
            pkg =
              if (user.hasAspect den.aspects.optional.bleeding-edge.chaotic)
              then pkgs.proton-cachyos
              else pkgs.proton-ge-bin;
          in [
            pkg
          ];
        };
      };
    };
  };
}
