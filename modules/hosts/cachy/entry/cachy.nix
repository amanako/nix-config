{
  den.hosts.x86_64-linux.cachy = {
    deviceType = "laptop";
    timeZone = "Europe/Belgrade";
    batteryID = "BAT0";

    repoRoot = "/etc/nixos";

    keyboardLightScript.device = "backlight:amdgpu_bl1";

    impermanence = {
      enableUser = false;
      persistenceDir = "/persist";
    };
  };
}
