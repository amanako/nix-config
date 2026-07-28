{den, ...}: {
  den.aspects.dev.shells.nushell = {
    description = "A modern shell written in Rust with structured data pipelines.";

    includes = [
      den.aspects.dev.shells.nushell.config-collector
      den.aspects.dev.shells.nushell.zellij
      den.aspects.dev.shells.nushell.completions
    ];

    persistUser.files = [
      ".config/nushell/history.txt"
    ];

    nushellConfig = ''
      $env.config.show_banner = false
    '';

    hm.programs.nushell = {
      enable = true;
    };
  };
}
