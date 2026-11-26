{den, ...}: {
  den.aspects.extra.gaming.unstable-packages = {
    description = "Unstable/git gaming packages from chaotic overlay (gamescope, steam, etc.).";

    includes = [
      den.aspects.extra.bleeding-edge.chaotic
    ];

    nixos = {pkgs, ...}: {
      programs.gamescope.package = pkgs.gamescope_git;
      programs.steam = {
        package = pkgs.jovian-chaotic.steam;
        # luxtorpeda's default output is a placeholder text file that must not
        # land in home.packages (buildEnv rejects non-directories). Its actual
        # content lives in the steamcompattool output, which this option uses.
        extraCompatPackages = [pkgs.luxtorpeda-bin_edge];
      };
    };
  };
}
