{
  den.schema.host = {lib, ...}: {
    options = {
      wantsSecureBootSupport = lib.mkEnableOption "secure boot support";

      batteryID = lib.mkOption {
        type = lib.types.str;
        description = ''
          Option named native-path assigned to batteries of pcs and laptops.
          Can be obtained by running `upower -b | grep -E 'vendor|model|native-path'`
          Currently used by ly display manager to display battery percentage.
        '';
      };

      limine.wallpapers = lib.mkOption {
        type = lib.types.listOf (lib.types.submoduleWith {
          modules = [
            {
              options.url = lib.mkOption {
                type = lib.types.str;
                default = "";
                description = "Remote url to be used to fetch wallpapers.";
              };

              options.hash = lib.mkOption {
                type = lib.types.str;
                default = "";
                description = ''
                  Hash used to compute corresponding wallpaper.
                  Can be obtained by running command once and looking at the error, copying it from there.
                '';
              };
            }
          ];
        });

        default = [];
        description = ''
          List of remote links of wallpapers to use for limine, Will be fetched and passed to
          `boot.loader.limine.style.wallpapers`.
        '';
      };

      keyboardLightScript = lib.mkOption {
        type = lib.types.submodule {
          options.device = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Keyboard light device name. Can be obtained via `nix run nixpkgs#brightnessctl -- -l`";
            example = "asus::kbd_backlight";
          };
          options.step = lib.mkOption {
            type = lib.types.int;
            default = 1;
            description = "Step to increase/decrease brightness on each script run";
            example = 5;
          };
        };
        description = ''
          Options passed to script created as `keyboard-light` executable taking increment and decrement parameters,
          tasked with changing keyboard backlight brightness on supported devices.
        '';
      };
    };
  };
}
