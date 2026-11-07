{
  den,
  inputs,
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

    imports = let
      c = host.defaultChannel;
    in {
      instantiate =
        inputs.${
          if c == "pkgs"
          then "nixpkgs"
          else "nixpkgs-${c}"
        }.lib.nixosSystem;
    };
  };
}
