{
  inputs,
  den,
  lib,
  ...
}: let
  persys = {host, ...}: {aspect-chain, ...}:
    den._.forward {
      each = lib.singleton true;
      fromClass = _item: "persys";
      intoClass = _item: "nixos";
      intoPath = _item: [
        "environment"
        "persistence"
        host.impermanence.persistenceDir
      ];
      fromAspect = _item: lib.head aspect-chain;
      adaptArgs = {config, ...}: {
        osConfig = config;
      };
      guard = {options, ...}: options ? environment.persistence;
    };

  persysUser = {
    host,
    user,
    ...
  }: {aspect-chain, ...}:
    den._.forward {
      each = lib.singleton true;
      fromClass = _item: "persysUser";
      intoClass = _item: "nixos";
      intoPath = _item: [
        "environment"
        "persistence"
        host.impermanence.persistenceDir
        "users"
        user.userName
      ];
      fromAspect = _item: lib.head aspect-chain;
      adaptArgs = {config, ...}: {
        osConfig = config;
      };
      guard = {options, ...}: options ? environment.persistence;
    };
in {
  flake-file.inputs = {
    disko.url = "github:nix-community/disko";
    impermanence.url = "github:nix-community/impermanence";
  };

  den.aspects.disko = {host, ...}: {
    nixos = {
      imports = [inputs.disko.nixosModules.disko];
      inherit (host) disko;
    };
  };

  den.aspects.impermanence = {host, ...}: {
    includes = [persys];
    nixos = {
      imports = [inputs.impermanence.nixosModules.impermanence];
      # This should be minimal for a truly pure setup
      fileSystems."${host.impermanence.persistenceDir}".neededForBoot = true;
    };
  };

  den.aspects.filesystem = {host, ...}: {
    includes =
      lib.optionals (host.disko.devices != {}) [den.aspects.disko]
      ++ lib.optionals (host.impermanence.enable) [den.aspects.impermanence];
  };

  den.aspects.timezone = {host, ...}: {
    nixos.time.timeZone = host.timeZone or "UTC";
  };

  den.aspects.base-host = den.lib.parametric {
    includes = [
      den._.hostname
      den.aspects.filesystem
      den.aspects.timezone
    ];
  };

  den.ctx.host.includes = [
    den.aspects.base-host
    den.aspects.overlays
  ];

  den.ctx.user.includes = [
    den._.define-user
    den._.mutual-provider
    # Currently this does nothing if host doesn't import impermanence
    persysUser
  ];
}
