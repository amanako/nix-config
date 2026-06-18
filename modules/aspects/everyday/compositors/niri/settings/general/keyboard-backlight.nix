{
  niri.binds.keyboard-backlight = {
    homeManager = {
      host,
      pkgs,
      lib,
      ...
    }:
      lib.optionalAttrs (host.keyboardLightScript.device != null) {
        programs.niri.settings.binds = let
          keyboardLightScriptPath = let
            brightnessCmd = lib.getExe pkgs.brightnessctl;
            inherit (host.keyboardLightScript) device;
          in
            pkgs.writeTextFile rec {
              name = "keyboard-light";
              executable = true;
              destination = "/bin/${name}";
              text = ''
                #!${lib.getExe pkgs.nushell}
                def update_brightness [command: string, percent = 0.10] {
                    let max_brightness = ^brightnessctl --device ${device} max | into int;
                    let step = [(($max_brightness | into float) * $percent | into int), 1] | math max;
                    let curr = ^${brightnessCmd} --device ${device} get | into int

                    match $command {
                        "increase" => ($curr + $step)
                        # Ensure command doesn't fail for negative values
                        "decrease" => ([ 0, ($curr - $step) ] | math max)
                        _ => {
                            print "Usage: $scriptname <increase|decrease>"
                            exit 1
                        }
                    }
                }

                def main [command: string, percent = 0.10] {
                  update_brightness $command $percent | ^brightnessctl --device "asus::kbd_backlight" set $in
                }
              '';
            };
          sh = cmd: {action.spawn-sh = cmd;};
        in {
          "Alt+Up" = sh "${lib.getExe keyboardLightScriptPath} increase";
          "Alt+Down" = sh "${lib.getExe keyboardLightScriptPath} decrease";
        };
      };
  };
}
