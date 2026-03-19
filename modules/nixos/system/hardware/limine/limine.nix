{ inputs, ... }:

{
  flake.modules.nixos.limine = {
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.limine = {
      enable = true;
      maxGenerations = 20;
      efiSupport = true;
      enableEditor = true;
    };
  };
}
