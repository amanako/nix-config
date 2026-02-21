{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    themeFile = "GruvboxMaterialDarkHard";
    font = {
      package = pkgs.nerd-fonts.victor-mono;
      size = 12;
    };
    enableGitIntegration = true;
    shellIntegration.enableFishIntegration = true;
    settings = {
      window_padding_width = 4;
    };
  };
}
