{ inputs, ... }:

{
  flake.hmModules.git = {
    programs.git = {
      enable = true;
    };
  };
}
