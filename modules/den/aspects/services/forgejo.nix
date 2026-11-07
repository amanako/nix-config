{
  inputs,
  lib,
  ...
}: {
  den.aspects.services.forgejo = {
    description = ''
      Forgejo is a cross-platform, open-source web server for hosting a software development forge.
      For usage with hosts acting as servers
    '';

    hostConflicts.assertions = [
      (
        {host, ...}: let
          isNormal = user: inputs.self.nixosConfigurations.${host.name}.config.users.users.${user}.isNormalUser;
          users =
            host.users
            |> builtins.attrNames
            |> lib.filter isNormal;
          forgejoUser = host.settings.services.forgejo.user;
        in [
          {
            target = "services.forgejo";
            subject = "multiple users";
            assertion = !(users |> lib.elem forgejoUser);
            message = {
              target,
              subject,
            }: ''
              ${target}: ${subject}: Login user under the name "${forgejoUser}" found!
              Please pick a dedicated system user for `${host.name}.settings.services.forgejo.user` or rename/remove normal user "${forgejoUser}".
            '';
          }
        ]
      )
    ];

    hostSettings = {host, ...}: let
      cfg = host.settings.services.forgejo;
    in {
      user = lib.mkOption {
        type = lib.types.str;
        example = "git";
        description = "User account under which forgejo instance runs.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = cfg.user;
        description = "Group of user \"${cfg.user}\". Read-only following the same user name.";
        readOnly = true;
      };

      persistDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/forgejo";
        example = "/var/forgejo";
        description = "Directory for keeping all persistent forgejo data.";
      };
    };

    persistHost = {host, ...}: let
      cfg = host.settings.services.forgejo;
    in {
      directories = [
        cfg.persistDir
      ];
    };

    nixos = {
      host,
      pkgs,
      ...
    }: let
      cfg = host.settings.services.forgejo;
    in {
      # Module system assertion fires if two users with the same name have different homes.
      # Temporary satisfy module system condition so the custom descriptive host assertion above fires instead.
      users = lib.optionalAttrs (!(host.users ? ${cfg.user})) {
        users.${cfg.user} = {
          home = cfg.persistDir;
          useDefaultShell = true;
          inherit (cfg) group;
          isSystemUser = true;
        };

        groups.${cfg.user} = {};
      };

      services.forgejo = {
        enable = true;
        package = pkgs.forgejo;
        inherit (cfg) user group;
        stateDir = cfg.persistDir;
      };
    };
  };
}
