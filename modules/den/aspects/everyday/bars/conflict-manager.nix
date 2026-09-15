{
  den,
  lib,
  ...
}: {
  den.aspects.everyday.bars.conflict-manager = {
    description = ''
      Aspect handling conflicts arising from usage of multiple bars at the same time by issuing a warning.
      Included by every bar aspect; only emits a warning when more than one bar is active.
    '';

    userConflicts.warnings = [
      ({user, ...}: let
        bars = [
          {
            name = "noctalia";
            aspect = den.ful.noctalia.bar;
          }
          {
            name = "noctalia-shell";
            aspect = den.ful.noctalia-shell.bar;
          }
          {
            name = "dms";
            aspect = den.ful.dms.bar;
          }
          {
            name = "waybar";
            aspect = den.aspects.everyday.bars.waybar;
          }
        ];
        active = bars |> lib.filter (bar: user.hasAspect bar.aspect);
      in
        lib.optional (builtins.length active > 1) {
          subject = ["everyday.bars.conflict-manager"];
          target = active |> map (bar: bar.name);
          message = {
            target,
            subject,
          }: ''
            ${subject |> lib.concatStringsSep "."}: Multiple aspects providing bars are included: (${target |> lib.concatStringsSep "\n"}).
            Running multiple top-layer bars is likely unintended; remove all but one choice if you did not intend to stack them.
          '';
        })
    ];
  };
}