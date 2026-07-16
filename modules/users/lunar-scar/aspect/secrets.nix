{
  den.aspects.lunar-scar.secrets = {
    hm = {
      user,
      lib,
      config,
      ...
    }: let
      # ENV VAR NAME -> sops secret attribute name (single source of truth)
      secretEnv = {
        OPENROUTER_API_KEY = "openrouter-api-key";
      };
    in {
      sops.secrets =
        lib.mapAttrs' (envVar: secret:
          lib.nameValuePair secret {
            sopsFile = user.settings.security.sops-user.secretsDir + "/${secret}.yaml";
          })
        secretEnv
        // {
          anki-key = {
            sopsFile = user.settings.security.sops-user.secretsDir + "/anki-key.yaml";
          };
        };

      # expose each as a *_FILE path (shell-agnostic, secret stays out of the store)
      home.sessionVariables =
        lib.mapAttrs' (
          envVar: secret:
            lib.nameValuePair "${envVar}_FILE" config.sops.secrets.${secret}.path
        )
        secretEnv;
    };
  };
}
