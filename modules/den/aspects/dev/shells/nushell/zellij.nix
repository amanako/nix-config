{
  den,
  lib,
  ...
}: {
  # Credits: https://www.grailbox.com/2023/07/autostart-zellij-in-nushell/.
  den.aspects.dev.shells.nushell.zellij = {
    includes = [
      (den.lib.policy.when ({user, ...}: let
        dependencies = [
          den.aspects.dev.terminal.zellij
          den.aspects.dev.shells.nushell
        ];
      in
        dependencies |> builtins.all (d: d |> user.hasAspect)) {
        hm = {user, ...}: let
          cfg = user.settings.dev.terminal.zellij;
        in {
          programs.nushell.extraConfig = ''
            $env.ZELLIJ_AUTO_ATTACH = ${cfg.autoAttach |> lib.boolToString}
            $env.ZELLIJ_AUTO_EXIT = ${cfg.autoExit |> lib.boolToString}

            if $env.ZELLIJ_AUTO_ATTACH {
              def start_zellij [] {
                # Don't start kitty quick access terminal in zellij since that isn't intended usage.
                if 'ZELLIJ' not-in ($env | columns) and 'KITTY_QUICK_ACCESS' not-in ($env | columns) {
                  zellij attach -c

                  if 'ZELLIJ_AUTO_EXIT' in ($env | columns) and $env.ZELLIJ_AUTO_EXIT {
                    exit
                  }
                }
              }

              start_zellij
            }
          '';
        };
      })
    ];
  };
}
