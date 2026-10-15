{
  den.hosts.aarch64-linux.kintoru = {
    defaultChannel = "stable";

    settings = {
      basic.time.timeZone = "Europe/Belgrade";

      core = {
        hardware.raspberry-pi = {
          board = "raspberry-pi-4";
          enableVc4 = true;
          enableUsbGadget = true;
        };
      };

      security.ssh = {
        permitRootLogin = "prohibit-password";
        rootAuthorizedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIPG5huz0B9qZ1gcuvMhCrc63piDJML/Hc/STMl55GWg awaremi"
        ];
      };
    };
  };
}
