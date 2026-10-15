{
  den,
  inputs,
  ...
}: {
  den.aspects.kintoru = {
    description = "Raspberry Pi 4 model B, 4GB RAM.";

    includes = [
      den.aspects.core.hardware.raspberry-pi.common
      den.aspects.core.nix.common
      den.aspects.core.nix.lix
      den.aspects.core.hardware.wireless-iwd

      den.aspects.security.ssh
    ];

    persistHost.directories = [
      "/etc/ssh"
    ];
  };
}
