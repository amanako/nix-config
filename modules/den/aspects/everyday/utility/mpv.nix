{
  den.aspects.everyday.utility.mpv = {
    description = "A free, open-source, and cross-platform media player.";

    hm.programs.mpv = {
      enable = true;
      bindings = {
        "h" = "seek -5";
        "l" = "seek 5";
      };
    };
  };
}
