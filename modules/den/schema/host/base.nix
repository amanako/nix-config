{
  inputs,
  lib,
  ...
}: {
  den.schema.host.options = let
    inherit
      (lib)
      mkOption
      types
      ;
  in {
    repoRoot = mkOption {
      type = types.path;
      example = "/etc/nixos";
      description = ''
        Root folder of repository where flake resides.
        Evaluation of this option is dependent on whether corresponding user option `user.repoRoot` is set.
        If no user is present or users haven't defined their option, assertion fails.
      '';
    };

    defaultChannel = let
      channelList =
        inputs
        |> builtins.attrNames
        |> lib.filter (name: lib.hasPrefix "nixpkgs" name)
        |> lib.map (
          name:
            if name == "nixpkgs"
            then "pkgs"
            else lib.removePrefix "nixpkgs-" name
        );
      # If flake has nixpkgs as an input, set option default to it.
      hasPkgs = channelList |> lib.elem "pkgs";
    in
      mkOption {
        type = types.enum channelList;
        example = lib.head channelList;
        description = ''
          Name of the flake input(without "nixpkgs-" prefix) to use as the default channel for unspecified packages,
          that is for those not explicitly set by packageChannel quirk.
        '';
      }
      // lib.optionalAttrs hasPkgs {
        default = "pkgs";
      };
  };
}
