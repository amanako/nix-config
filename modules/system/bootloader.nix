{
  # Limine simple setup.
  # Don't forget to changeup boot order for configuration to take effect.
  # For example: efibootmgr -o ENTRIES and(or) efibootmgr -b ENTRY -B
  # OR change them in BIOS.
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
    };
    limine = {
      enable = true;
      maxGenerations = 20;
      efiSupport = true;
      enableEditor = true;
    };
  };
}
