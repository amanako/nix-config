{den, ...}: {
  # Credits: https://www.grailbox.com/2023/07/autostart-zellij-in-nushell/
  den.aspects.shell.interpreters.nu.autostart-zellij = {
    includes = [
      (den.lib.policy.when ({user, ...}: user.hasAspect den.aspects.terminal.zellij && user.hasAspect den.aspects.shell.interpreters.nu) {
        hm = {
          home.sessionVariables = {
            "ZELLIJ_AUTO_ATTACH" = true;
            "ZELLIJ_AUTO_EXIT" = true;
          };

          programs.nushell.extraConfig = ''
            def start_zellij [] {
              if 'ZELLIJ' not-in ($env | columns) {
                if 'IS_ZELLIJ_AUTO_ATTACH' in ($env | columns) and $env.IS_ZELLIJ_AUTO_ATTACH == 'true' {
                  zellij attach -c
                } else {
                  zellij
                }

                if 'IS_ZELLIJ_AUTO_EXIT' in ($env | columns) and $env.IS_ZELLIJ_AUTO_EXIT == 'true' {
                  exit
                }
              }
            }

            start_zellij
          '';
        };
      })
    ];
  };
}
