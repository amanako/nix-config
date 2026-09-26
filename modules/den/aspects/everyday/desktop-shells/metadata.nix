{
  den,
  lib,
  ...
}: {
  den.aspects.everyday.desktop-shells.metadata = {
    description = ''
      Metadata about desktop shells active for the current user.
      Exposes the list of included desktop shells so other aspects can
      react to their presence (e.g. claim keybinds only when no shell does).
    '';

    userSettings = {user, ...}: let
      # The `.niri` sub-aspect of each shell is what claims the compositor
      # keybinds, so it is the marker for "this shell is active": the same
      # list the launchers conflict-manager uses to detect shell launchers.
      shells = [
        {
          name = "noctalia";
          aspect = den.ful.noctalia.niri;
        }
        {
          name = "noctalia-shell";
          aspect = den.ful.noctalia-shell.niri;
        }
        {
          name = "dms";
          aspect = den.ful.dms.niri;
        }
      ];
    in {
      activeShells = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default =
          shells
          |> lib.filter (shell: user.hasAspect shell.aspect)
          |> map (shell: shell.name);
        description = "Names of the desktop shells active for the current user.";
        readOnly = true;
      };
    };
  };
}
