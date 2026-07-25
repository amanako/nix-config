{
  den.aspects.security.gpg = {
    nushellConfig = ''
      $env.GPG_TTY = (tty | str trim)
    '';

    hm = {
      pkgs,
      config,
      ...
    }: {
      programs.gpg.enable = true;

      programs.nushell.extraConfig = ''
        $env.GNUPGHOME = '${config.programs.gpg.homedir}'
      '';

      services.gpg-agent = {
        enable = true;
        pinentry.package = pkgs.pinentry-curses;
      };
    };
  };
}
