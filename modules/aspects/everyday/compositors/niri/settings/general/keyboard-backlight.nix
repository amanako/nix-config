{
  niri.binds.keyboard-backlight = {
    hm = {
      host,
      pkgs,
      lib,
      ...
    }:
      lib.optionalAttrs (host.keyboardLightScript.device != null) {
        programs.niri.settings.binds = let
          keyboardLightScriptPath = let
            brightnessCmd = pkgs.brightnessctl |> lib.getExe;
            inherit (host.keyboardLightScript) device;
          in
            pkgs.writeTextFile rec {
              name = "keyboard-light";
              executable = true;
              destination = "/bin/${name}";
              text = ''
                #!${pkgs.nushell |> lib.getExe}
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
          "Alt+Up" = sh "${keyboardLightScriptPath |> lib.getExe} increase";
          "Alt+Down" = sh "${keyboardLightScriptPath |> lib.getExe} decrease";
        };
      };
  };
}
