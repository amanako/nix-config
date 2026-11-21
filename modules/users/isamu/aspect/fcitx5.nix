{den, ...}: {
  den.aspects.isamu.fcitx5 = {
    includes = [
      den.aspects.utilities.fcitx5
    ];

    # Addons require access to pkgs instance but fcitx5 is a quirk for settings only.
    # Therefore, define a homeManager class to append addons
    hm = {pkgs, ...}: {
      i18n.inputMethod.fcitx5.addons = with pkgs; [
        # Basic GUI for configuration
        fcitx5-gtk
      ];
    };

    # Reference: https://wiki.nixos.org/wiki/Fcitx5#Configuration
    fcitx5Settings = {
      inputMethod = {
        # Niri does not let fcitx5 change the compositor XKB layout (only GNOME/KDE can), so the real keymap stays us.
        # Fcitx5's keyboard engine only does its own keycode→keysym translation when the current IM's layout differs from the group's Default Layout;
        # Otherwise it "uses system one" and passes niri's us keysyms through.
        GroupOrder = {
          "0" = "SR - Cyrilic";
          "1" = "SR - Latin";
          "2" = "Default";
        };

        "Groups/0" = {
          Name = "SR - Cyrilic";
          "Default Layout" = "us";
          DefaultIM = "keyboard-rs-alternatequotes";
        };
        "Groups/0/Items/0".Name = "keyboard-rs-alternatequotes";

        "Groups/1" = {
          Name = "SR - Latin";
          "Default Layout" = "us";
          DefaultIM = "keyboard-rs-latinalternatequotes";
        };
        "Groups/1/Items/0".Name = "keyboard-rs-latinalternatequotes";

        "Groups/2" = {
          Name = "Default";
          "Default Layout" = "us";
          DefaultIM = "keyboard-us";
        };
        "Groups/2/Items/0".Name = "keyboard-us";
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
}
