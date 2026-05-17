{
  den.hosts.x86_64-linux.nebula = {
    deviceType = "laptop";
    timeZone = "Europe/Belgrade";
    batteryID = "BAT1";

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

    # Changing default directory implicitly enables module
    impermanence.persistenceDir = "/persist";
  };
}
