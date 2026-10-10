{
  den,
  inputs,
  lib,
  ...
}: let
  allHosts =
    den.hosts
    |> lib.concatMapAttrs (_arch: hosts: hosts);

  nixosConfig = hostname: inputs.self.nixosConfigurations.${hostname}.config;

  # Surface the actual image file(s) from disko's output directory so the
  # package is directly burnable (e.g. `dd if=$(nix build ... --print-out-paths)`),
  # rather than handing back the `$out` directory.
  diskoImage = pkgs: hostname: let
    config = nixosConfig hostname;
    imageFormat = config.disko.imageBuilder.imageFormat;
    images =
      config.disko.devices.disk
      |> lib.mapAttrsToList (_: disk: "${disk.imageName}.${imageFormat}");
  in
    if lib.length images == 1
    then
      pkgs.runCommand "${hostname}-image" {} ''
        ln -s ${config.system.build.diskoImages}/${lib.head images} $out
      ''
    else
      pkgs.runCommand "${hostname}-image" {} ''
        mkdir -p $out
        ${lib.concatMapStrings (image: "ln -s ${config.system.build.diskoImages}/${image} $out/${image}\n") images}
      '';

  # Prefer disko and only fallback to sd-image since they are incompatible.
  imageOf = pkgs: hostname: let
    build = (nixosConfig hostname).system.build;
  in
    if build ? diskoImages
    then diskoImage pkgs hostname
    else if build ? sdImage && lib.isDerivation build.sdImage
    then build.sdImage
    else null;
in {
  perSystem = {pkgs, ...}: {
    packages =
      allHosts
      |> lib.mapAttrs (hostname: _: imageOf pkgs hostname)
      |> lib.filterAttrs (_: value: value != null)
      |> lib.mapAttrs' (hostname: value: {
        name = "${hostname}-image";
        inherit value;
      });
  };
}
