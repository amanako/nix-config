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
    packages = lib.mapAttrs' (hostname: host: {
      name = "${hostname}-vm";

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
