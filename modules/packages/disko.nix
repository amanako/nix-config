{
  den,
  inputs,
  lib,
  ...
}: let
  cfg = hostname:
    inputs.self.nixosConfigurations.${hostname}.config.disko.devices or {};

  # Recursively drop `_`-prefixed keys from the disko devices config. Aspects use
  # `_`-named attrs for internal/metadata helpers (e.g. `_priority`), which disko
  # would reject if serialized into the generated disko config file.
  stripInternals = value:
    if lib.isAttrs value
    then
      value
      |> lib.filterAttrs (name: _: !lib.hasPrefix "_" name)
      |> lib.mapAttrs (_: stripInternals)
    else value;
in {
  perSystem = {
    pkgs,
    system,
    ...
  }: {
    packages = lib.mapAttrs' (hostname: host: let
      devices = cfg hostname;
    in {
      name = "${hostname}-disko";

      value = lib.mkIf (devices != {}) (
        pkgs.writeShellApplication {
          name = "${hostname}-disko";
          text = let
            diskoFile = pkgs.writeText "${hostname}-disko-config.nix" ''
              {
                disko.devices = ${pkgs.lib.generators.toPretty {} (devices |> stripInternals)};
              }
            '';
          in ''
            sudo nix --experimental-features "nix-command flakes" run \
            github:nix-community/disko/latest \
            -- --mode destroy,format,mount ${diskoFile}
          '';
        }
      );
    }) (den.hosts.${system} or {});
  };
}
