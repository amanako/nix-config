{
  den.aspects.lunar-scar = {
    # Addons require access to pkgs instance but fcitx5 is a static class.
    # Therefore, define a homeManager class to append addons
    homeManager = {pkgs, ...}: {
      i18n.inputMethod.fcitx5.addons = with pkgs; [
        # Basic GUI for configuration
        fcitx5-gtk
        # JP IME
        fcitx5-mozc-ut
      ];
    };

    # Reference: https://wiki.nixos.org/wiki/Fcitx5#Configuration
    fcitx5 = {
      settings = {
        inputMethod = {
          GroupOrder = {
            "0" = "Default";
            "1" = "JP";
            "2" = "SR - Latin";
            "3" = "SR - Cyrilic";
          };

          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "keyboard-us";
          };
          "Groups/0/Items/0".Name = "keyboard-us";

          "Groups/1" = {
            Name = "JP";
            "Default Layout" = "us";
            DefaultIM = "mozc";
          };
          "Groups/1/Items/0".Name = "mozc";

          "Groups/2" = {
            Name = "SR - Latin";
            "Default Layout" = "rs-latinalternatequotes";
            DefaultIM = "keyboard-rs-latinalternatequotes";
          };
          "Groups/2/Items/0".Name = "keyboard-rs-latinalternatequotes";

          "Groups/3" = {
            Name = "SR - Cyrilic";
            "Default Layout" = "us";
            DefaultIM = "keyboard-rs-alternatequotes";
          };
          "Groups/3/Items/0".Name = "keyboard-rs-alternatequotes";
        };

        globalOptions = {
          Behavior = {
            ActiveByDefault = true;
            resetStateWhenFocusIn = "No";
            ShareInputState = "All";
            PreeditEnabledByDefault = true;
            ShowInputMethodInformation = true;
            showInputMethodInformationWhenFocusIn = false;
            CompactInputMethodInformation = true;
            ShowFirstInputMethodInformation = true;
            DefaultPageSize = 5;
            PreloadInputMethod = true;
            AllowInputMethodForPassword = false;
            ShowPreeditForPassword = false;
            AutoSavePeriod = 30;
          };

          # Hotkey settings
          Hotkey = {
            EnumerateWithTriggerKeys = true;
            EnumerateSkipFirst = true;
            ModifierOnlyKeyTimeout = 252;
          };

          "Hotkey/TriggerKeys"."0" = "Control+space";
          "Hotkey/AltTriggerKeys"."0" = "Shift_L";
          "Hotkey/EnumerateGroupForwardKeys"."0" = "Alt+space";
          "Hotkey/EnumerateGroupBackwardKeys"."0" = "Alt+Shift+space";
          "Hotkey/PrevCandidate"."0" = "Shift+Tab";
          "Hotkey/NextCandidate"."0" = "Tab";
        };
      };
    };
  };
}
