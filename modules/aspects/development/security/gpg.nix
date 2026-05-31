{
  den.aspects.security.gpg = {
    homeManager = {pkgs, ...}: {
      programs.gpg.enable = true;

      services.gpg-agent = {
        enable = true;
        pinentry.package = pkgs.pinentry-curses;
        enableFishIntegration = true;
      };
    };
  };
}
