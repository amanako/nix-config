{
  den,
  lib,
  inputs,
  ...
}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: {
    legacyPackages.vms = lib.mapAttrs' (hostname: host: {
      name = hostname;

      value = pkgs.writeShellApplication {
        name = "${hostname}-vm";
        text = let
          host = inputs.self.nixosConfigurations.${hostname}.config;
        in ''
          ${host.system.build.vm}/bin/run-${host.networking.hostName}-vm "$@"
        '';
      };
    }) (den.hosts.${system} or {});
  };
}
