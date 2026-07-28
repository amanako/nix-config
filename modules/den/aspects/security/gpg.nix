{
  den.aspects.security.gpg = {
    description = "GNU Privacy Guard — encryption and signing tool configuration.";

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
