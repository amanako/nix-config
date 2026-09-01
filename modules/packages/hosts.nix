{
  den,
  inputs,
  ...
}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: {
    packages.hosts =
      den.hosts.${system} or {}
      |> builtins.attrNames
      |> map (hostname: inputs.self.nixosConfigurations.${hostname}.config.system.build.toplevel)
      |> pkgs.linkFarmFromDrvs "hosts";
  };
}