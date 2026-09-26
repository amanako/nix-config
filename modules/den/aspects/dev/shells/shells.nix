{
  den,
  lib,
  ...
}: let
  fallbackShell = "bash";

  # All direct shell-defining subaspects under dev.shells, excluding the
  # auxiliary default-shell-setter and `_`-prefixed internal keys. Shared so
  # the includes guard and the activeShells setting don't walk the tree twice.
  shellNames =
    den.aspects.dev.shells
    |> lib.filterAttrs (n: v: (v |> builtins.isAttrs) && !(n |> lib.hasPrefix "_"))
    |> builtins.attrNames
    |> lib.remove "default-shell-setter";

  # Only shells the user actually included, read via structural membership.
  # The guard in `includes` cannot read `settings` (settings are generated from
  # the tree), so the hasAspect test is duplicated here by necessity.
  activeShellsOf = user:
    shellNames
    |> lib.filter (shell:
      user.hasAspect {
        name = shell;
        meta.provider = ["dev" "shells"];
      });
in {
  den.aspects.dev.shells = {
    includes = [
      den.aspects.dev.shells.default-shell-setter
      (
        den.lib.policy.when ({user, ...}: let
          anyShellIncluded = activeShellsOf user != [];
        in
          !anyShellIncluded)
        den.aspects.dev.shells.${fallbackShell}
      )
    ];

    userSettings = {user, ...}: let
      activeShells = activeShellsOf user;
      cfg = user.settings.dev.shells;
    in {
      activeShells = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = activeShells;
        description = ''
          Shells the user actually includes, derived once from the aspect tree.
          Read this instead of re-deriving from den.aspects.dev.shells and hasAspect.
        '';
        readOnly = true;
      };

      defaultShell = lib.mkOption {
        default =
          if activeShells == []
          then fallbackShell
          else activeShells |> lib.head;
        example =
          if activeShells == []
          then fallbackShell
          else activeShells |> lib.last;
        type = lib.types.enum (lib.unique (activeShells ++ [fallbackShell]));
        description = ''
          Default login and user shell to use.
          The corresponding den.aspects.dev.shells.${cfg.defaultShell} must be included for shell to be registered here.
          When no shell is included, ${fallbackShell} is used and included automatically.
        '';
      };
    };
  };
}
