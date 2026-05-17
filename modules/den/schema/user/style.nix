{
  lib,
  den,
  ...
}: let
  # Activated only when user context present
  stylixHomeClass = {user, ...}:
    den.batteries.forward {
      each = lib.singleton true;
      fromClass = _: "stylixHome";
      intoClass = _: "homeManager";
      intoPath = _: ["stylix"];
      guard = {options, ...}: options ? stylix;
    };
in {
  den.schema.user.includes = [
    # Allow users to modify stylix settings regarding home manager programs
    stylixHomeClass
  ];
}
