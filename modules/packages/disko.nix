{ den, lib, ... }:

{
  perSystem =
    { pkgs, system, ... }:
    {
      packages = lib.mapAttrs' (hostname: host: {
        name = "${hostname}-disko";

        value = lib.mkIf (host.disko.devices or { } != { }) (
          pkgs.writeShellApplication {
            name = "${hostname}-disko";
            text =
              let
                diskoFile = pkgs.writeText "${hostname}-disko-config.nix" ''
                  {
                    disko.devices = ${pkgs.lib.generators.toPretty { } host.disko.devices};
                  }
                '';
              in
              ''
                sudo nix --experimental-features "nix-command flakes" run \
                github:nix-community/disko/latest \
                -- --mode destroy,format,mount ${diskoFile}
              '';
          }
        );
      }) (den.hosts.${system} or { });
    };
}
