{den, ...}: {
  den.aspects.dev.shells.nushell = {
    description = "A modern shell written in Rust with structured data pipelines.";

    includes = [
      den.aspects.dev.shells.nushell.zellij
      den.aspects.dev.shells.nushell.completions
      den.aspects.dev.shells.nushell.export-home-variables
    ];

    persistUser.files = [
      ".config/nushell/history.txt"
    ];

    hm.programs.nushell = {
      enable = true;

      extraConfig = ''
        $env.config.show_banner = false
      '';
    };
  };
}
