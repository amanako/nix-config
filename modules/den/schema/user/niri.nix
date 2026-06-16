{
  den,
  lib,
  ...
}: let
  niriSettingsClass = den.batteries.forward {
    each = lib.singleton true;
    fromClass = _: "niriSettings";
    intoClass = _: "homeManager";
    intoPath = _: ["programs" "niri" "settings"];
    guard = {options, ...}: _item: lib.optionalAttrs (options ? programs.niri);
  };
in {
  niri.entry.includes = [niriSettingsClass];
}
