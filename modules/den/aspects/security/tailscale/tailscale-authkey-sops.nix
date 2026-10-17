{den, ...}: {
  flake.den = den;
  den.aspects.security.tailscale.authkey-sops = {
    description = ''
      Authenticate Tailscale with this host's sops-encrypted auth key.
      Reads `tailscale-authkey.yaml` (key `key`) from the host's
      `security.sops-host.secretsDir`, so every host needs its own encrypted
      copy of the key.
    '';

    includes = [
      den.aspects.security.tailscale
      den.aspects.security.sops-host
    ];

    nixos = {
      host,
      config,
      ...
    }: {
      sops.secrets.tailscaleKey = {
        key = "key";
        sopsFile = host.settings.security.sops-host.secretsDir + "/tailscale-authkey.yaml";
      };

      services.tailscale.authKeyFile = config.sops.secrets.tailscaleKey.path;
    };
  };
}
