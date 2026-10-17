{lib, ...}: let
  inherit
    (lib)
    mkOption
    types
    ;
in {
  den.aspects.security.ssh = {
    description = "OpenSSH secure shell client and server configuration.";

    hostSettings = {
      permitRootLogin = mkOption {
        type = types.enum [
          "yes"
          "without-password"
          "prohibit-password"
          "forced-commands-only"
          "no"
        ];
        default = "no";
        description = "Value for sshd PermitRootLogin.";
      };

      rootAuthorizedKeys = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Public keys allowed to log in as root.";
      };
    };

    nixos = {host, ...}: let
      cfg = host.settings.security.ssh;
    in {
      services.openssh = {
        enable = true;
        settings = {
          # Security hardening
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          PermitRootLogin = cfg.permitRootLogin;
        };
      };

      users.users.root.openssh.authorizedKeys.keys = cfg.rootAuthorizedKeys;
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
