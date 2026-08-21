{
  den,
  lib,
  ...
}: let
  fallbackShell = "bash";
in {
  den.aspects.dev.shells = {
    includes = [
      den.aspects.dev.shells.default-shell-setter
      (
        den.lib.policy.when ({user, ...}: let
          anyShellIncluded =
            den.aspects.dev.shells
            |> lib.filterAttrs (n: v: (v |> builtins.isAttrs) && !(n |> lib.hasPrefix "_"))
            |> builtins.attrNames
            |> lib.remove "default-shell-setter"
            |> lib.any (shell: den.aspects.dev.shells.${shell} |> user.hasAspect);
        in
          !anyShellIncluded)
        den.aspects.dev.shells.${fallbackShell}
      )
    ];

    userSettings = {user, ...}: let
      availableShells =
        den.aspects.dev.shells
        # Remove all functions and lists(includes above) like this parametric userSettings and internal attrsets - which typically begin with _.
        # Only count attribute sets since they have been resolved properly.
        |> lib.filterAttrs (n: v: (v |> builtins.isAttrs) && !(n |> lib.hasPrefix "_"))
        # Supposing only shells remain create a list from them
        |> builtins.attrNames
        # Remove other subaspects whose purpose is not a shell definition.
        |> lib.remove "default-shell-setter"
        # Only shells which user actually included will be displayed
        |> lib.filter (shell: den.aspects.dev.shells.${shell} |> user.hasAspect);
      cfg = user.settings.dev.shells;
    in {
      defaultShell = lib.mkOption {
        default =
          if availableShells == []
          then fallbackShell
          else availableShells |> lib.head;
        example =
          if availableShells == []
          then fallbackShell
          else availableShells |> lib.last;
        type = lib.types.enum (lib.unique (availableShells ++ [fallbackShell]));
        description = ''
          Default login and user shell to use.
          The corresponding den.aspects.dev.shells.${cfg.defaultShell} must be included for shell to be registered here.
          When no shell is included, ${fallbackShell} is used and included automatically.
        '';
      };
    };
  };
}
