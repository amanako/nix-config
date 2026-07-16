{den, ...}: {
  den.aspects.nebula.secrets = {
    # Showcase usage of hashed password for users.
    # For each user who set their password in host file "user-passwords.yaml" extract hashed password by key.
    # Reference: https://github.com/Mic92/sops-nix#setting-a-users-password.
    provides.to-users = {user, ...}: (den.lib.policy.when ({user, ...}: user.hasAspect den.aspects.security.sops) {
      nixos = {host, ...}: {
        sops.secrets."${user.userName}-hashed-password" = let
          cfg = host.settings.security.sops;
        in {
          neededForUsers = true;
          key = user.userName;
          sopsFile = cfg.secretsDir + "/user-passwords.yaml";
        };
      };

      user = {config, ...}: {
        hashedPasswordFile = config.sops.secrets."${user.userName}-hashed-password".path;
      };
    });
  };
}
