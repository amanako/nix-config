{
  den.aspects.utility.youtubeTUI = {
    description = ''
      Aesthetically pleasing YouTube TUI written in Rust.
    '';

    persistUser = {
      directories = [
        ".local/share/youtube-tui/channels"
        ".local/share/youtube-tui/info"
      ];

      files = [
        ".local/share/youtube-tui/subscriptions.json"
        ".local/share/youtube-tui/watch_history.json"
      ];
    };

    desktopEntries = {
      "youtube-tui" = {
        name = "Youtube TUI";
        type = "Application";
        terminal = true;
        exec = "youtube-tui";
        comment = "Youtube content viewer in terminal";
        genericName = "Aesthetically pleasing YouTube TUI written in Rust";
      };
    };

    hm = {pkgs, ...}: {
      home.packages = [
        pkgs.youtube-tui
      ];
    };
  };
}
