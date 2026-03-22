{ inputs, ... }:

{
  flake.hmModules.ssh = {
    programs.ssh = {
      enable = true;
    };
  };
}
