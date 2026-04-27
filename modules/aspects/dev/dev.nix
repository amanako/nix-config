{
  den.aspects.dev = {
    nixos = {
      services.openssh = {
        enable = true;
        settings = {
          # Security hardening
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          PermitRootLogin = "no";
        };
      };
    };

    homeManager = {pkgs, ...}: {
      programs.gpg.enable = true;
      programs.git.signing.signByDefault = true;

      services.gpg-agent = {
        enable = true;
        pinentry.package = pkgs.pinentry-curses;
        enableFishIntegration = true;
        enableSshSupport = true;
      };
    };
  };
}
