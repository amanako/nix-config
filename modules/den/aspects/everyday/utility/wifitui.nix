{lib, ...}: {
  den.aspects.everyday.utility.wifitui = {
    description = "Terminal user interface for managing Wi-Fi connections.";

    hm = {pkgs, ...}: let
      inherit (pkgs) wifitui;
    in {
      xdg.desktopEntries."${wifitui.pname}" = {
        name = "Internet";
        type = "Application";
        terminal = true;
        icon = "network-wireless";
        exec = wifitui |> lib.getExe;
        comment = "Wi-Fi TUI utility";
        categories = ["Utility" "Network"];
      };
    };
  };
}
