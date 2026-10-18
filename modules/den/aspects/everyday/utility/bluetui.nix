{lib, ...}: {
  den.aspects.everyday.utility.bluetui = {
    description = "Terminal user interface for managing Bluetooth devices.";

    hm = {pkgs, ...}: let
      inherit (pkgs) bluetui;
    in {
      xdg.desktopEntries."${bluetui.pname}" = {
        name = "Bluetooth";
        type = "Application";
        terminal = true;
        icon = "bluetooth";
        exec = bluetui |> lib.getExe;
        comment = "Bluetooth TUI utility";
        categories = ["Utility" "Network"];
      };
    };
  };
}
