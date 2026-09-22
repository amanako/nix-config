{
  niri.niriSettingsCollector = {
    description = ''
      Aspect assembling all of settings emitted by niriSettings quirk.
    '';

    hm = {
      niriSettings,
      user,
      pkgs,
      lib,
      inputs',
      ...
    }: let
      resolveContribution = contribution: let
        fn =
          if builtins.isAttrs contribution && contribution ? __fn
          then contribution.__fn
          else contribution;
      in
        if builtins.isFunction fn
        then fn {inherit user pkgs lib inputs';}
        else contribution;
      # A keybind may declare exactly one action. When several contributors
      # try to claim the same keybind, the
      # recursiveUpdate merges their `action` into multiple keys, which
      # violates niri's `kdl leaf` type before conflict quirk fires.
      # Coerce such keybinds back to a single action so the conflict surfaces as
      # a `userConflicts` assertion instead of an upstream kdl type error.
      coalesceAction = keybind:
        if keybind ? action && builtins.length (lib.attrNames keybind.action) > 1
        then let
          actionName = builtins.head (lib.attrNames keybind.action);
        in
          keybind
          // {
            action = builtins.listToAttrs [
              {
                name = actionName;
                value = keybind.action.${actionName};
              }
            ];
          }
        else keybind;

      normalizeBinds = settings:
        settings
        // lib.optionalAttrs (settings ? binds) {
          binds = settings.binds |> lib.mapAttrs (_: coalesceAction);
        };
    in {
      # Reference: https://github.com/sodiboo/niri-flake/blob/main/docs.md#programsnirisettings
      programs.niri.settings =
        # First parameter represents name of attribute list to use(can be omitted in this case).
        # Second one is list of all elements in this attribute set.
        # Concatenate lists keeping only unique one's and deep merge attribute sets similarly to den's freeform approach.
        niriSettings
        |> map resolveContribution
        |> lib.zipAttrsWith (
          _: values: let
            allLists =
              values
              |> (builtins.all builtins.isList);
            allAttrs =
              values
              |> (builtins.all builtins.isAttrs);
          in
            if allLists
            then
              values
              |> builtins.concatLists
              |> lib.unique
            else if allAttrs
            then
              values
              |> lib.foldl' lib.recursiveUpdate {}
            else
              values
              |> builtins.head
        )
        |> lib.recursiveUpdate {
          includes = lib.mkAfter [
            ./blur.kdl
          ];

          xwayland-satellite.path =
            inputs'.niri-pkgs.packages.xwayland-satellite-unstable
            |> lib.getExe;

          animations.slowdown = 1.5;
        }
        |> normalizeBinds;
    };
  };
}
