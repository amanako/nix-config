{ inputs, ... }:

{
  flake.hmModules.mpv = {
    programs.mpv = {
      enable = true;
      bindings = {
        "h" = "seek -5";
        "l" = "seek 5";
      };
    };
  };
}
