{
  den,
  __findFile,
  ...
}: {
  den.aspects.nebula = {
    includes = [
      den.aspects.nebula._
      den.aspects.boot.optional._
      den.aspects.performance._
      <displayManagers/ly>
      <boot/loader/limine>
      <nix>
      <nix/lix>
    ];

    nixos.boot.loader.limine.style.wallpaperStyle = "centered";
  };
}
