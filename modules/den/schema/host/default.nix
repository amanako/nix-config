{
  den,
  inputs,
  lib,
  ...
}: {
  den.schema.host = {host, ...}: {
    includes = [
      den.batteries.hostname
      # User aspects intentionally provide system-wide content (fonts, ssh,
      # flatpak, niri, steam, ...). Accept it explicitly instead of relying on
      # den's transition default, which a release planned for 2027-01-01 drops.
      den.batteries.user-aspects
      den.batteries.mutual-provider
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
