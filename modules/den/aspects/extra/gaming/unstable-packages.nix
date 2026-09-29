{den, ...}: {
  den.aspects.extra.gaming.unstable-packages = {
    description = "Unstable/git gaming packages from chaotic overlay (gamescope, steam, etc.).";

    includes = [
      den.aspects.extra.bleeding-edge.chaotic
    ];

    nixos = {
      user,
      pkgs,
      lib,
      ...
    }:
      lib.optionalAttrs (user.hasAspect den.aspects.extra.bleeding-edge.chaotic) {
        programs.gamescope.package = pkgs.gamescope_git;
        programs.steam.package = pkgs.jovian-chaotic.steam;
      };

    hm = {
      user,
      lib,
      pkgs,
      ...
    }:
      lib.optionalAttrs (user.hasAspect den.aspects.extra.bleeding-edge.chaotic) {
        home.packages = with pkgs; [
          luxtorpeda # Steam compatibility tool
        ];
      };
  };
}
