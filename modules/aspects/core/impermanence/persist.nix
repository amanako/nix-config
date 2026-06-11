{
  den,
  lib,
  ...
}: let
  persistHostClass = {host}:
    den.batteries.forward {
      each = lib.singleton true;
      fromClass = _: "persys";
      intoClass = _: "nixos";
      intoPath = _: ["environment" "persistence" host.impermanence.persistenceDir];
      adaptArgs = {config, ...}: {osConfig = config;};
      guard = {options, ...}: options ? environment.persistence && host.impermanence.enableSystem;
    };

  persistUserClass = {
    host,
    user,
  }:
    den.batteries.forward {
      each = lib.singleton true;
      fromClass = _: "persysUser";
      intoClass = _: "nixos";
      intoPath = _: ["environment" "persistence" host.impermanence.persistenceDir "users" user.userName];
      adaptArgs = {config, ...}: {osConfig = config;};
      guard = {options, ...}: options ? environment.persistence && host.impermanence.enableHome;
    };
in {
  den.aspects.core.impermanence.classes = {
    includes = [
      persistHostClass
      persistUserClass
    ];
  };
}
