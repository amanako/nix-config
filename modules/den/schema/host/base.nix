{
  inputs,
  lib,
  ...
}: let
  inherit
    (lib)
    mkOption
    types
    ;
in {
  den.schema.host.options = {
    repoRoot = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/etc/nixos";
      description = ''
        Root folder of repository where flake resides.
        Optional; defaults to null and is used as the default for `user.repoRoot`.
        Set it when included aspects need to read files from the repository.
      '';
    };

    defaultChannel = let
      channelList =
        inputs
        |> builtins.attrNames
        |> lib.filter (name: lib.hasPrefix "nixpkgs" name);
      # If flake has a root nixpkgs input, set option default to it.
      hasRoot = channelList |> lib.elem "nixpkgs";
    in
      mkOption {
        type = types.enum channelList;
        example = lib.head channelList;
        description = ''
          Name of the nixpkgs flake input (e.g. `nixpkgs` or `nixpkgs-stable`) to
          use as the default channel for unspecified packages, that is for those
          not explicitly set by the packageChannels quirk.
        '';
      }
      // lib.optionalAttrs hasRoot {
        default = "nixpkgs";
      };
  };
}
