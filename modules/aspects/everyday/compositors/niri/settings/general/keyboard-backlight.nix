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
          in
            pkgs.writeTextFile rec {
              name = "keyboard-light";
              executable = true;
              destination = "/bin/${name}";
              text = ''
                #!${pkgs.nushell |> lib.getExe}
                def find_new_brightness [device: string, command: string, percent: float] {
                    let max_brightness = ^${brightnessCmd} --device $device max | into int
                    let step = [(($max_brightness | into float) * $percent | into int), 1] | math max
                    let curr = ^${brightnessCmd} --device $device get | into int

                    match $command {
                        "increase" => ($curr + $step)
                        # Ensure command doesn't fail for negative values
                        "decrease" => ([ 0, ($curr - $step) ] | math max)
                        _ => {
                            print "Usage: ${name} <device> <increase|decrease> [percent]"
                            exit 1
                        }
                    }
                }

                def main [device: string, command: string, percent = 0.10] {
                  find_new_brightness $device $command $percent | ^${brightnessCmd} --device $device set $in
                }
              '';
            };
          sh = cmd: {action.spawn-sh = cmd;};
          inherit (host.keyboardLightScript) device;
        in {
          "Alt+Up" = sh "${keyboardLightScriptPath |> lib.getExe} ${device} increase";
          "Alt+Down" = sh "${keyboardLightScriptPath |> lib.getExe} ${device} decrease";
        };
      };
  };
}
