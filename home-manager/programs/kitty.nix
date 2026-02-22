{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    themeFile = "Apprentice";
    font = {
      name = "Victor Mono NF";
      package = pkgs.nerd-fonts.victor-mono;
      size = 12;
    };
    enableGitIntegration = true;
    shellIntegration.enableFishIntegration = true;
    settings = {
      window_padding_width = 4;
      hide_window_decorations = true;
      cursor_trail = 5;
    };
  };
}
