{den, ...}: {
  den.aspects.extra.gaming.unstable-packages = {
    description = "Unstable/git gaming packages from chaotic overlay (gamescope, steam, etc.).";

    includes = [
      den.aspects.extra.bleeding-edge.chaotic
    ];

    nixos = {pkgs, ...}: {
      programs.gamescope.package = pkgs.gamescope_git;
      programs.steam.package = pkgs.jovian-chaotic.steam;
    };

    hm = {pkgs, ...}: {
      home.packages = with pkgs; [
        luxtorpeda # Steam compatibility tool
      ];
    };
  };
}
