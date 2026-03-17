{ inputs, ... }:

{
  flake.hmModules.zoxide = {
    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
