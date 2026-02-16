{ pkgs, ... }:

{
  qt = {
    enable = true;
    platformTheme.name = "kde";
    style.name = "breeze";
  };
  home.file.".config/kdeglobals" = {
    text = ''
      ${builtins.readFile "${pkgs.kdePackages.breeze}/share/color-schemes/BreezeDark.colors"}
      '';
  };
}
