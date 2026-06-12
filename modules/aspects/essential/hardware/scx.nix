{den, ...}: {
  den.aspects.hardware.scx = {
    nixos = {
      host,
      pkgs,
      lib,
      ...
    }:
      lib.optionalAttrs (host.hasAspect den.aspects.optional.bleeding-edge.chaotic) {
        services.scx = {
          enable = true;
          package = pkgs.scx_git.full;
        };
      };
  };
}
