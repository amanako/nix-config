{den, ...}: {
  flake.den = den;
  den.aspects.gaming.chaotic-integration = {
    nixos = {
      user,
      pkgs,
      lib,
      ...
    }:
      lib.optionalAttrs (user.hasAspect den.aspects.optional.bleeding-edge.chaotic) {
        programs.gamescope.package = pkgs.gamescope_git;
        programs.steam.package = pkgs.jovian-chaotic.steam;
      };

    homeManager = {
      user,
      lib,
      pkgs,
      ...
    }:
      lib.optionalAttrs (user.hasAspect den.aspects.optional.bleeding-edge.chaotic) {
        home.packages = with pkgs; [
          luxtorpeda
        ];
      };
  };
}
