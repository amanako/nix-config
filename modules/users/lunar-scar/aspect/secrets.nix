{
  den.aspects.lunar-scar.secrets = {
    hm = {
      user,
      lib,
      config,
      ...
    }: let
      # attrset of environment variables mapping to file names in assets/users/lunar-scar/secrets folder -> sops secret attribute name (single source of truth).
      # Secrets listed here are exposed as environment variables in one shared
      # env file (see sops.templates."secrets.env" below), sourced by shells or
      # referenced via EnvironmentFile in systemd services.
      #
      # NOTE: the keys in this shared env file are only delivered to the
      # environment automatically when the vixd daemon (`runDaemonService`) is
      # enabled, as that is the only currently wired consumer (via
      # `EnvironmentFile`). Disabling the daemon means the keys are decrypted to
      # disk but NOT injected into the environment — for non-daemon use you must
      # source `secrets.env` manually or configure the provider key in `~/.vix/`.
      secretEnv = {
        OPENROUTER_API_KEY = "openrouter-api-key";
      };
      # Only emit an `export` line for secrets that are actually declared, so a
      # user without (e.g.) an OpenRouter key still gets a valid env file.
      envLines =
        secretEnv
        |> lib.mapAttrsToList (envVar: secret:
          lib.optionalString (builtins.hasAttr secret config.sops.secrets)
          "${envVar}=\"${config.sops.placeholder.${secret}}\"")
        |> lib.concatStringsSep "\n";
    in {
      sops.secrets = let
        mapped =
          secretEnv
          |> lib.mapAttrsToList (envVar: secret:
            lib.nameValuePair secret {
              sopsFile = user.settings.security.sops-user.secretsDir + "/${secret}.yaml";
            });
      in
        builtins.listToAttrs mapped
        // {
          anki-key = {
            sopsFile = user.settings.security.sops-user.secretsDir + "/anki-key.yaml";
          };
        };

      # One shared env file holding all environment variables.
      # Cleartext is substituted at activation time by sops-nix and written to a
      # runtime-dir file (symlinked under ~/.config/sops-nix); it never enters
      # /nix/store. Consumers either `source` this file in a shell, or reference
      # it via `EnvironmentFile = config.sops.templates."secrets.env".path`
      # (e.g. in a systemd user service for any coding agent).
      sops.templates."secrets.env" = {
        content = ''
          ${envLines}
        '';
        mode = "0400";
      };
    };
  };
}
