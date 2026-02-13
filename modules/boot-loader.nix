{ pkgs, config , ... }:

{
  # Systemd setup from first install.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  # Limine simple setup.
  # Don't forget to changeup boot order for configuration to take effect.
  # For example: efibootmgr -o ENTRIES and(or) efibootmgr -b ENTRY -B
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
    };
    limine = {
      enable = true;
      # Optionally enable if space on boot partition is critical.
      # maxGenerations = 20;
      efiSupport = true;
      enableEditor = true;
    };
  };
}
