{
  den,
  lib,
  inputs,
  ...
}: {
  flake-file.inputs.sops-nix.url = "github:Mic92/sops-nix";

  den.aspects.security.sops-host = let
    inherit
      (lib)
      mkIf
      mkOption
      types
      ;
  in {
    description = "Sops-nix secret management for machine secrets.";

    hostSettings = {host, ...}: {
      sshKeyPaths = mkOption {
        type = lib.types.listOf lib.types.path;
        default = [];
        example = ["/etc/ssh/ssh_host_ed25519_key"];
        description = ''
          Path to ssh host private keys sops-nix derives age recipients from for decryption.
          Should be specified WITHOUT persist mounpoint.
          Must be persisted across reboots for ephemeral systems, otherwise
          the host can no longer decrypt its own secrets after a reboot.
          Either set this or ${host.hostName}.settings.security.sops.ageKeyFile, but not both as it's unnecessary.
        '';
      };

      ageKeyFile = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "/etc/sops/key.txt";
        description = ''
          Optional dedicated age key file used for decryption instead of deriving it
          from SSH host keys. Must be persisted across reboots for ephemeral setups.
          Should be specified WITHOUT persist mounpoint.
          Either set this or ${host.hostName}.settings.security.sops.ageKeyFile, but not both as it's unnecessary.
        '';
      };

      defaultSopsFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = /. + "${host.repoRoot}/assets/.sops.yaml";
        description = ''
          Default sops file used for every secret that does not set `sopsFile`
          explicitly. With host/user-scoped secret directories there is no single
          default, so set this per host or pass `sopsFile` on each secret.
        '';
      };

      # Store-imported directory of this host's encrypted secrets. The path is
      # relative to this aspect module so Nix copies the files into the store
      # (sops-install-secrets reads them inside a pure-eval sandbox, where an
      # absolute `repoRoot` path is invisible). Reference a secret with
      # `sopsFile = host.settings.security.sops.secretsDir + "/name.yaml"`.
      secretsDir = mkOption {
        type = types.path;
        default = ../../../../assets/hosts/${host.hostName}/secrets;
        description = ''
          Directory of this host's encrypted secret files, imported into the Nix
          store. Convenience tool. Use it to set `sopsFile` on host secrets without hardcoding a
          relative path in every declaration.
        '';
      };
    };

    persistSystem = {host, ...}: let
      cfg = host.settings.security.sops-host;
    in {
      directories = lib.optionals (cfg.sshKeyPaths != null) [
        "/etc/ssh"
      ];

      files = lib.optionals (cfg.ageKeyFile != null) [
        cfg.ageKeyFile
      ];
    };

    nixos = {host, ...}: let
      cfg = host.settings.security.sops-host;
      # Prefix the path for ephemeral hosts where necessary
      persistenceDir =
        den.aspects.core.impermanence
        |> host.hasAspect
        |> lib.flip lib.optionalString host.settings.core.impermanence.persistenceDir;
    in {
      imports = [inputs.sops-nix.nixosModules.sops];

      # A host must be able to decrypt its secrets: either via SSH host keys or a
      # dedicated age key file. Fail fast here, since a silent decryption failure
      # at activation (secrets simply not mounting) is hard to debug.
      assertions = [
        {
          assertion =
            cfg.sshKeyPaths != [] || cfg.ageKeyFile != null;
          message = "security.sops: set either `${host.hostName}.settings.security.sops.sshKeyPaths` or `${host.hostName}.settings.security.sops.ageKeyFile`
          so the host can decrypt its secrets.";
        }
      ];

      sops = {
        age.sshKeyPaths =
          lib.optionals (cfg.sshKeyPaths != null)
          cfg.sshKeyPaths
          |> map (path: persistenceDir + path);

        age.keyFile =
          mkIf
          (cfg.ageKeyFile != null)
          "${persistenceDir}${cfg.ageKeyFile}";

        defaultSopsFile =
          mkIf
          (cfg.defaultSopsFile != null)
          cfg.defaultSopsFile;
      };
    };
  };
}
