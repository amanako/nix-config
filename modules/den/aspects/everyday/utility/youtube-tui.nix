{lib, ...}: {
  den.aspects.everyday.utility.youtube-tui = {
    description = ''
      Aesthetically pleasing YouTube TUI written in Rust.
    '';

    persistUser.directories = [
      ".local/share/youtube-tui"
    ];

    hm = {pkgs, ...}: {
      home.packages = [
        pkgs.youtube-tui
      ];

      xdg.desktopEntries."youtube-tui" = {
        name = "Youtube TUI";
        type = "Application";
        terminal = true;
        exec = pkgs.youtube-tui |> lib.getExe;
        comment = "Youtube content viewer in terminal";
        genericName = "Aesthetically pleasing YouTube TUI written in Rust";
      };
    };
  };
}
