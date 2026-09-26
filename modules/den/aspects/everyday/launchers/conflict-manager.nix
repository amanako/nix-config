{
  den,
  lib,
  ...
}: {
  den.aspects.everyday.launchers.conflict-manager = {
    description = ''
      Aspect handling conflicts arising from usage of multiple launchers at the same time throwing an assertion.
      Included by every launcher-providing aspect; asserts when more than one launcher is active.
    '';

    userConflicts.assertions = [
      ({user, ...}: let
        launchers = [
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
          {
            name = "vicinae";
            aspect = den.aspects.everyday.launchers.vicinae;
          }
        ];
        active = launchers |> lib.filter (launcher: user.hasAspect launcher.aspect);
      in [
        {
          subject = ["everyday.launchers.conflict-manager"];
          target = active |> map (launcher: launcher.name);
          assertion = builtins.length active <= 1;
          message = {
            subject,
            target,
          }: ''
            ${subject |> lib.concatStringsSep "."}: Multiple aspects providing launchers are active: (${target |> lib.concatStringsSep "\n"}).
            They would all claim the same keybinding and the compositor would silently grant it to an unspecified winner; keep exactly one launcher.
          '';
        }
      ])
    ];
  };
}
