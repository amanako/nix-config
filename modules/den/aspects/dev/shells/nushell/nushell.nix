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

    hm = {
      pkgs,
      config,
      ...
    }: let
      nixYourShellFile = "${config.xdg.configHome}/nushell/nix-your-shell.nu";
    in {
      # Ensure correct shell preservation with nix, nix-shell and other commands.
      home.file."${nixYourShellFile}".source =
        pkgs.nix-your-shell.generate-config "nu";

      programs.nushell = {
        enable = true;
        extraConfig = ''
          $env.config.show_banner = false
          source "${nixYourShellFile}"
        '';
      };
    };
  };
}
