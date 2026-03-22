{ inputs, ... }:

{
  # Used to display battery precentage and other battery-related info
  flake.modules.nixos.upower = {
    services.upower.enable = true;
  };
}
