{
  den.aspects.security.gpg = {
    hm = {pkgs, ...}: {
      programs.gpg.enable = true;

      services.gpg-agent = {
        enable = true;
        pinentry.package = pkgs.pinentry-curses;
        enableFishIntegration = true;
      };
    };
  };
}
