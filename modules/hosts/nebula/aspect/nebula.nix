{__findFile, ...}: {
  den.aspects.nebula = {
    includes = [
      <nebula/hardware>
      <boot/loader/limine>
      <boot/optional/plymouth>
      <boot>
      <performance>
      <displayManagers/ly>
      <utility>
    ];

    nixos.boot.loader.limine.style.wallpaperStyle = "centered";
  };
}
