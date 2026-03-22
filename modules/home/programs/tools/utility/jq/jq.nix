{ inputs, ... }:

{
  flake.hmModules.jq = {
    programs.jq.enable = true;
  };
}
