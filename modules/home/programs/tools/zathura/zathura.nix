{ inputs, ... }:

{
  flake.hmModules.zathura = {
    programs.zathura = {
      enable = true;
      options = {

      };
      #extraConfig = {
      #
      #};
    };
  };
}
