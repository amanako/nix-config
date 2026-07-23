{
  den.aspects.dev.shells.nushell = {
    persistUser.files = [
      ".config/nushell/history.txt"
    ];

    hm = {config, ...}: {
      programs.nushell = {
        enable = true;
        extraConfig = ''
          $env.GPG_TTY = (tty | str trim)

          # nushell doesn't inherit home.sessionVariables like bash/fish do,
          # so env vars set by home-manager modules must be redeclared here.
          $env.GNUPGHOME = '${config.programs.gpg.homedir}'
          $env.NH_FLAKE = '${config.programs.nh.flake}'
        '';
      };
    };
  };
}
