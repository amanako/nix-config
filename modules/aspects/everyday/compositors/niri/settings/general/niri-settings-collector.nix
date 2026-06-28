{
  niri.niriSettingsCollector = {
    description = ''
      Aspect assembling all of settings emitted by niriSettings quirk.
    '';

    hm = {
      niriSettings,
      lib,
      inputs',
      ...
    }: {
      # Reference: https://github.com/sodiboo/niri-flake/blob/main/docs.md#programsnirisettings
      programs.niri.settings =
        # First parameter represents name of attribute list to use(can be omitted in this case).
        # Second one is list of all elements in this attribute set.
        # Concatenate lists keeping only unique one's and deep merge attribute sets similarly to den's freeform approach.
        niriSettings
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
        };
    };
  };
}
