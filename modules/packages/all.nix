{lib, ...}: {
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    packages.all =
      config.packages
      |> lib.flip removeAttrs ["all"]
      |> builtins.attrValues
      |> pkgs.linkFarmFromDrvs "all";
  };
}
