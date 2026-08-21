{
  den.aspects.security.gpg = {
    description = "GNU Privacy Guard — encryption and signing tool configuration.";

    hm = {
      pkgs,
      config,
      ...
    }: {
      programs.gpg.enable = true;

      home.sessionVariables.GNUPGHOME = config.programs.gpg.homedir;

      # Dynamic value, cannot live in home.sessionVariables.
      programs.nushell.extraConfig = ''
        $env.GPG_TTY = (tty | str trim)
      '';

      services.gpg-agent = {
        enable = true;
        pinentry.package = pkgs.pinentry-curses;
      };
    };
  };
}
