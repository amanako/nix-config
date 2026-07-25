{den, ...}: {
  den.aspects.dev.shells.nushell = {
    includes = [
      den.aspects.dev.shells.nushell.config-collector
      den.aspects.dev.shells.nushell.zellij
      den.aspects.dev.shells.nushell.completions
    ];

    persistUser.files = [
      ".config/nushell/history.txt"
    ];


    hm.programs.nushell = {
      enable = true;
    };
  };
}
