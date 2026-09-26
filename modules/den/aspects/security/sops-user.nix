{
  lib,
  inputs,
  ...
}: {
  den.aspects.security.sops-user = let
    inherit
      (lib)
      mkIf
      mkOption
      types
      ;
  in {
    description = "Sops-nix secret management for user secrets.";

    userSettings = {user, ...}: {
      ageKeyFile = mkOption {
        type = types.str;
        example = ".config/sops/age/keys.txt";
        description = ''
          Age key file the user decrypts secrets with, relative to user's home directory.
          Should be specified WITHOUT persist mounpoint.
          Must be set explicitly; there is no default.
        '';
      };

      defaultSopsFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "${user.repoRoot}/assets/users/${user.userName}/secrets/default.yaml";
        description = ''
          Default sops file for the user's secrets. With host/user-scoped secret
          directories there is no single default, so set this per user or pass
          `sopsFile` on each secret.
        '';
      };

      # Store-imported directory of this user's encrypted secrets. The path is
      # relative to this aspect module so Nix copies the files into the store
      # (sops-install-secrets reads them inside a pure-eval sandbox, where an
      # absolute `repoRoot` path is invisible). Reference a secret with
      # `sopsFile = user.settings.security.sops.secretsDir + "/name.yaml"`.
      secretsDir = mkOption {
        type = types.path;
        default = ../../../../assets/users/${user.userName}/secrets;
        description = ''
          Directory of this user's encrypted secret files, imported into the Nix
          store. Convenience tool. Use it to set `sopsFile` on user secrets without hardcoding a
          relative path in every declaration.
        '';
      };
    };

    persistUser = {user, ...}: {
      files = [
        user.settings.security.sops-user.ageKeyFile
      ];
    };

    hm = {
      host,
      user,
      config,
      ...
    }: let
      cfg = user.settings.security.sops-user;
      absolutePath = config.home.homeDirectory + "/" + cfg.ageKeyFile;

      # Prefix the path for ephemeral hosts where host doesn't have /home as persistent.
      # Marked as mountHomeDir = false.
      # Since host.hasAspect returns false in user context of home manager read settings configuration obtained BY including den.aspects.core.impermanence
      # Settings returns empty attribute set by default so it's safe to access host.settings
      persistenceDir =
        host.settings
        |> lib.hasAttrByPath ["core" "impermanence"]
        |> lib.flip lib.and (!host.settings.core.impermanence.mountHomeDir)
        |> lib.flip lib.optionalString host.settings.core.impermanence.persistenceDir;
    in {
      imports = [inputs.sops-nix.homeManagerModules.sops];

      # Export a variable to be able to decrypt files when changing/re-crypting passwords
      home.sessionVariables."SOPS_AGE_KEY_FILE" = absolutePath;

      sops = {
        # Since path is relative to home directory append one / for full path.
        # On ephemeral hosts prefix with the persistent mount so the key survives reboots.
        age.keyFile = persistenceDir + absolutePath;
        defaultSopsFile = mkIf (cfg.defaultSopsFile != null) cfg.defaultSopsFile;
      };
    };
  };
}
