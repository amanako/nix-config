{
  den,
  lib,
  ...
}: {
  den.aspects.dev.terminal.kitty = {
    description = "A fast, feature-rich GPU-based terminal emulator.";

    stylixHMSettings.targets."kitty".enable = false;

    niriSettings.binds = {
      "Mod+W".action.spawn-sh = "kitten quick-access-terminal";
    };

    userSettings = {
      fontFeatures = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "JetBrainsMono-Regular +ss01 +zero";
        description = ''
          OpenType features to enable or disable, passed to kitty as
          `font_features` in HarfBuzz syntax, e.g. `+liga -dlig`.
          Every entry may be prefixed with the PostScript name of a face, which
          scopes its features to that face only, so a bare list of features
          applies to whatever font ends up being matched, typically a fallback
          font. Home Manager's kitty `font` option carries no features, hence
          the preferred font is configured here.
          Both the PostScript name and the wanted features are shown by
          `kitten choose-font`.
          `null` leaves the setting unset and lets kitty and fontconfig decide.
        '';
      };
    };

    hm = {
      user,
      lib,
      pkgs,
      ...
    }: let
      cfg = user.settings.dev.terminal.kitty;
      monofont = user.preferences.monofont;
      package =
        lib.attrByPath (lib.splitString "." monofont.package)
        (throw "no package named \"${monofont.package}\" in nixpkgs (preferred font)")
        pkgs;
      fontFeatures = lib.optionalAttrs (cfg.fontFeatures != null) {
        font_features = cfg.fontFeatures;
      };
    in {
      programs.kitty = {
        enable = true;
        themeFile = "GruvboxMaterialDarkSoft";
        font = {
          inherit package;
          inherit (monofont) name;
          size = 14;
        };

        enableGitIntegration =
          den.aspects.dev.shell-tools.git
          |> user.hasAspect;
        shellIntegration.mode = "enabled";

        settings =
          {
            confirm_os_window_close = -1;
            window_padding_width = 4;
            hide_window_decorations = true;

            # Cursor movement
            cursor_trail = 1;
            cursor_trail_start_threshold = 2;
            cursor_blink_interval = "-1 ease-in-out";
            cursor_stop_blinking_after = 0;
            cursor_trail_decay = "0.15 0.3";
          }
          // fontFeatures;

        keybindings = {
          # Allow for the keybinding to serve a dual purpose based on whether text is selected
          "ctrl+c" = "copy_or_interrupt";

          # Tell new tabs and windows to start in same directory
          "ctrl+shift+t" = "new_tab_with_cwd";
          "ctrl+shift+enter" = "new_window_with_cwd";

          "Alt+h" = "previous_tab";
          "Alt+l" = "next_tab";

          "Alt+j" = "previous_window";
          "Alt+k" = "next_window";
        };

        quickAccessTerminalConfig = {
          lines = 10;
          columns = 60;
          hide_on_focus_loss = true;
          # Set environment variable to inform other programs if necessary.
          kitty_override = "env KITTY_QUICK_ACCESS=1";
        };
      };
    };
  };
}
