{
  den.aspects.security.ssh = {
    nixos.services.openssh = {
      enable = true;
      settings = {
        # Security hardening
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    homeManager = {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
      };

      services.ssh-agent.enable = true;
    };
  };
}
