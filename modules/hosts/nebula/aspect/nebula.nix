{__findFile, ...}: {
  den.aspects.nebula = {
    includes = [
      <nebula/hardware>
      <bootloader/limine>
      <boot>
      <performance>
      <displayManagers/ly>
      <utility>
    ];

    nixos = {
      boot.loader.limine.style.wallpaperStyle = "centered";
    };
  };
}
