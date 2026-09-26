{
  den.aspects.everyday.utility.mpv = {
    description = "A free, open-source, and cross-platform media player.";

    persistUser.files = let
      basePath = ".config/mpv/";
    in
      [
        "mpvBookmark.log"
        "mpvHistory.log"
      ]
      |> map (path: basePath + path);

    hm = {pkgs, ...}: {
      programs.mpv = {
        enable = true;
        package = pkgs.mpv.override {
          scripts = with pkgs.mpvScripts; [
            # Integrate with mpris
            mpris
            # Updates to OSC
            modernz
            # Skip sponsors
            sponsorblock

            eisa01.smartskip
            eisa01.undoredo
            eisa01.simplehistory
            eisa01.simplebookmark
          ];
        };

        bindings = {
          "h" = "seek -5";
          "l" = "seek 5";
        };
        config = {
          osc = "no";
          border = "no";
        };
      };
    };
  };
}
