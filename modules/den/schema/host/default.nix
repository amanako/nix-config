{
  den,
  inputs,
  lib,
  ...
}: {
  den.schema.host = {host, ...}: {
    includes = [
      den.batteries.hostname
      den.aspects.basic.time
      den.aspects.basic.conflicts-collector
      den.aspects.basic.channel-collector
      den.aspects.basic.no-primary-user-lockout
      den.aspects.basic.nscd-start-limit
    ];

    imports = {
      instantiate = inputs.${host.defaultChannel}.lib.nixosSystem;
      home-manager.module =
        inputs.${lib.replaceStrings ["nixpkgs"] ["home-manager"] host.defaultChannel}.nixosModules.home-manager;
    };
  };
}
