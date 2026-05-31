{
  den,
  lib,
  ...
}: {
  den.schema.user = {
    options.gc = lib.mkOption {
      default = "none";
      example = "nh";
      type = lib.types.enum [
        "none"
        "nix-gc"
        "nh"
      ];
      description = ''
        Which method to use for garbage collecting operations.
        Nix-gc will use current builtin nix-collect-garbage command.
        Nh is a modern implementation for various nix commands, including gc.
      '';
    };

    config.includes = [
      (
        {user}: let
          aspects = {
            nix-gc = "nix.gc";
            nh = "nix.nh";
          };
          tryGetAspect = aspect:
            if builtins.hasAttr aspect aspects
            then den.aspects.${builtins.getAttr aspect aspects}
            else {};
        in
          tryGetAspect user.gc
      )
    ];
  };
}
