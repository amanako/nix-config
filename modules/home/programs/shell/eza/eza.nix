{ inputs, ... }:

{
  flake.hmModules.eza = {
    programs.eza = {
      enable = true;
      enableFishIntegration = true;
      icons = "always";
    };
  };
}
