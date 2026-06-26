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

    hm = {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
      };

      services.ssh-agent.enable = true;
    };
  };
}
