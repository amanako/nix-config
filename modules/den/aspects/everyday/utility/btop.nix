{lib, ...}: {
  den.aspects.everyday.utility.btop = {
    description = "A responsive system monitor with a curses interface.";

    hm = {pkgs, ...}: let
      inherit (pkgs) btop;
    in {
      programs.btop.enable = true;

      xdg.desktopEntries."${btop.pname}" = {
        name = "Btop";
        type = "Application";
        terminal = true;
        icon = "btop";
        exec = btop |> lib.getExe;
        comment = "System info TUI utility";
        categories = ["Utility" "System"];
      };
    };
  };
}
