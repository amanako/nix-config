{
  den.schema.user = {
    config,
    lib,
    ...
  }: {
    options.awww = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable =
            lib.mkEnableOption "awww wallpaper manager"
            // {
              default = let
                inherit (config) awww;
                scriptDefaultValuesChanged = awww.script.label != "awww-randomizer" || awww.script.args != [];
                serviceDefaultValuesChanged = awww.service.label != awww.script.label || awww.service.interval != "30min" || awww.service.calendar != null;
              in
                scriptDefaultValuesChanged || serviceDefaultValuesChanged;
            };

          script = lib.mkOption {
            type = lib.types.submodule {
              options = {
                label = lib.mkOption {
                  default = "awww-randomizer";
                  example = "wallpaper-switch";
                  type = lib.types.str;
                  description = "Name to use for the script";
                };

                args = lib.mkOption {
                  default = [];
                  example = [
                    "--transition-type wave"
                    "--resize=fit"
                  ];
                  type = lib.types.listOf lib.types.str;
                  description = ''
                    Arguments to pass to the script. Reference: https://codeberg.org/LGFae/awww#usage.
                  '';
                };

                exposePackage =
                  lib.mkEnableOption "expose script as a home manager package"
                  // {
                    default = true;
                    description = "This option is great one-time invoking function and testing functionality";
                  };
              };
            };
          };

          service = lib.mkOption {
            type = lib.types.submodule {
              options = {
                label = lib.mkOption {
                  default = config.awww.script.label;
                  example = "awww-rand-service";
                  type = lib.types.str;
                  description = ''
                    Name to use for the service.
                    I'd recommend keeping it same as script name for convenience.
                  '';
                };

                interval = lib.mkOption {
                  default =
                    if config.awww.service.calendar == null
                    then "30min"
                    else null;
                  example = "2h";
                  type = lib.types.nullOr lib.types.str;
                  description = ''
                    Value for systemd's OnUnitActiveSec. Fires this long after the initial activation.
                    Reference https://www.freedesktop.org/software/systemd/man/latest/systemd.time.html.
                  '';
                };

                calendar = lib.mkOption {
                  default = null;
                  type = lib.types.nullOr lib.types.str;
                  example = "daily";
                  description = ''
                    Value for systemd's OnCalendar to fire the script.
                    When both this option and `user.awww.service.interval` are set, the timer fires when EITHER condition is met.
                    Reference https://www.freedesktop.org/software/systemd/man/latest/systemd.timer.html.
                  '';
                };
              };
            };
          };
        };
      };

      default = {};
    };
  };
}
