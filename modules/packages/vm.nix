# enables `nix run .#vm`. it is very useful to have a VM
# you can edit your config and launch the VM to test stuff
# instead of having to reboot each time.
{
  den,
  lib,
  inputs,
  ...
}:

{
  perSystem =
    { pkgs, system, ... }:
    {
      packages = lib.mapAttrs' (hostname: host: {
        name = "${hostname}-vm";

        value = pkgs.writeShellApplication {
          name = "${hostname}-vm";
          text =
            let
              host = inputs.self.nixosConfigurations.${hostname}.config;
            in
            ''
              ${host.system.build.vm}/bin/run-${host.networking.hostName}-vm "$@"  
            '';
        };
      }) (den.hosts.${system} or { });
    };
}
