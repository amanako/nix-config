{
  den.aspects.dev.shells.nushell.export-home-variables = {
    description = ''
      Aspect to export variables from `home.sessionVariables` to `programs.nushell.extraEnv`.
      Fix for nushell not reading variables from .profile path resulting in them not being sourced.
      Particularly made for users using nushell as their default/login shell.
    '';

    hm = {
      user,
      lib,
      config,
      ...
    }: let
      # `or null` guards against the settings namespace collapsing entirely
      # (see settings.nix pruning fallbacks), mirroring default-shell-setter.
      defaultShell = user.settings.dev.shells.defaultShell or null;
    in
      lib.optionalAttrs (defaultShell == "nushell") {
        programs.nushell.extraEnv =
          config.home.sessionVariables
          |> lib.mapAttrsToList (name: val: "$env.${name} = '${toString val}'")
          |> lib.concatStringsSep "\n";
      };
  };
}
