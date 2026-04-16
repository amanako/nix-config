{ den, lib, ... }:

let
  persys =
    { class, aspect-chain }:
    den._.forward {
      each = lib.singleton true;
      fromClass = _item: "persys";
      intoClass = _item: class;
      intoPath =
        _item:
        { config, ... }:
        [
          "environment"
          "persistence"
          # config.impermanence.persistence-dir
        ];
      fromAspect = _item: lib.head aspect-chain;
      guard = { options, ... }@osArgs: options ? environment.persistence;
    };
in
{
  den.aspects.timezone =
    { host, ... }:
    {
      nixos.time.timeZone = host.timeZone;
    };

  den.aspects.base-host = den.lib.parametric {
    includes = [
      den._.hostname
      den.aspects.timezone
    ];
  };

  den.ctx.host.includes = [
    den.aspects.base-host
    den.aspects.overlays
    # TODO: Fix
    # persys
  ];

  den.ctx.user.includes = [
    den._.define-user
  ];
}
