{
  nixvim.plugins.rainbow-delimiters = {user, ...}: {
    homeManager.programs.nixvim.plugins.rainbow-delimiters = {
      enable = true;
      # Careful comparison lead me to believe this combination fits best
      settings.highlight = [
        "RainbowDelimiterCyan"
        "RainbowDelimiterViolet"
        "RainbowDelimiterYellow"
      ];
    };
  };
}
