{
  den,
  lib,
  ...
}: {
  niri.binds.system = {
    description = ''
      Compositor-level keybinds for volume, brightness, and system control.
      Only emitted when no desktop shell is included: desktop shells claim these
      bindings themselves, so they are skipped while one is present.
    '';

    includes = [
      den.aspects.everyday.desktop-shells.metadata
    ];

    niriSettings = {
      user,
      pkgs,
      lib,
      ...
    }:
      lib.optionalAttrs (user.settings.everyday.desktop-shells.metadata.activeShells == []) {
        binds = let
          sh = cmd: {action.spawn-sh = cmd;};

          wpctl = lib.getExe' pkgs.wireplumber "wpctl";
          brightnessctl = lib.getExe pkgs.brightnessctl;
          systemctl = lib.getExe' pkgs.systemd "systemctl";
        in {
          "XF86MonBrightnessDown" = sh "${brightnessctl} set 5%-";
          "XF86MonBrightnessUp" = sh "${brightnessctl} set 5%+";

          "XF86AudioMute" = sh "${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle";
          "XF86AudioLowerVolume" = sh "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          "XF86AudioRaiseVolume" = sh "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%+";

          "Alt+Shift+H" = sh "${systemctl} hibernate";
          "Mod+X" = sh "${systemctl} poweroff";
        };
      };
  };
}
