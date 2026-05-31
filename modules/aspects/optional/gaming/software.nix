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

          extraCompatPackages = with pkgs; [
            proton-ge-bin
          ];
        };
      };
    };
  };
}
