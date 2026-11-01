{lib, ...}: let
  schemaKinds = [
    "host"
    "user"
    "home"
    "flake"
  ];
in {
  # Enable use of freeform attributes to enforce consistency.
  # "aspect" kind is left out on purpose since it is demanding to implement.
  # Reference: https://den.denful.dev/explanation/entities/#strict-mode
  den.schema =
    lib.genAttrs schemaKinds (_: {isStrict = true;});
}
