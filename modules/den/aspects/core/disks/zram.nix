{
  den.aspects.core.disks.zram = {
    description = ''
      Enable in-memory compressed device. Includes a few tweaks.
    '';

    nixos = {lib, ...}: {
      zramSwap = {
        enable = true;
        memoryPercent = lib.mkDefault 75;
      };

      boot.kernel.sysctl = {
        "vm.swappiness" = lib.mkDefault 100;
        # Don't read ahead extra pages from zram
        "vm.page-cluster" = lib.mkDefault 0;
      };
    };
  };
}
