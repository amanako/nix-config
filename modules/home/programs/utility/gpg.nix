{ inputs, ... }:

{
  flake.hmModules.gpg = {
    programs.gpg.enable = true;
  };
}
