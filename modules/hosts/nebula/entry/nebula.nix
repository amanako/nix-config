{
  den.hosts.x86_64-linux.nebula = {
    deviceType = "laptop";
    timeZone = "Europe/Belgrade";
    batteryID = "BAT1";
    wantsSecureBootSupport = true;

    gpus = [
      {
        type = "nvidia";
        busId = "PCI:0@1:0:0";
      }
      {
        type = "amd";
        busId = "PCI:0@5:0:0";
      }
    ];

    keyboardLightScript.device = "asus::kbd_backlight";

    impermanence.persistenceDir = "/persist";

    limine.wallpapers = [
      {
        url = "https://cdn.cloudflare.steamstatic.com/steam/apps/2712550/library_hero.jpg";
        # Hash can be obtained by trying to rebuild system without specifying hash, which will
        # prompt user with hash mismatch error. The message then contains correct hash in "got" row
        # that is the one beginning with sha256 and not full of uppercase As
        hash = "sha256-gcVUDQ9YXgA9fB5Mn8yqPfEwP2OSX9ssrNwLYcwN+cI=";
      }
    ];
  };
}
