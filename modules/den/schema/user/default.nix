{
  __findFile,
  den,
  lib,
  ...
}: {
  flake.den = den;
  den.schema.user = {
    includes = [
      <den.batteries.define-user>
      <den.batteries.mutual-provider>
    ];
    classes = lib.mkDefault ["homeManager"];
  };
}
