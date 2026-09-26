{
  den,
  inputs,
  lib,
  ...
}: let
  getDiskoCfg = hostname:
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

  # Disko config is just serialized partition data, independent of the target
  # arch, so generate a disko package for every host regardless of which arch
  # the package is evaluated for.
  allHosts =
    den.hosts
    |> lib.concatMapAttrs (_arch: hosts: hosts);
in {
  perSystem = {pkgs, ...}: {
    packages =
      lib.mapAttrs' (hostname: host: let
        devices = hostname |> getDiskoCfg;
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
              ${pkgs.sudo |> lib.getExe} ${pkgs.nix |> lib.getExe} --experimental-features "nix-command flakes" run \
              github:nix-community/disko/latest \
              -- --mode destroy,format,mount ${diskoFile}
            '';
          }
        );
      })
      allHosts;
  };
}
