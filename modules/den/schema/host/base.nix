{
  __findFile,
  lib,
  ...
}: {
  den.schema = {
    host.includes = [
      <den.batteries.hostname>
      <timezone>
    ];

    host.options = {
      repoRoot = lib.mkOption {
        example = "/etc/nixos";
        type = lib.types.path;
        description = ''
          Root folder of repository where flake resides.
          Evaluation of this option is dependent on whether corresponding user option `user.repoRoot` is set.
          If no user is present or users haven't defined their option, assertion fails.
        '';
      };

      timeZone = lib.mkOption {
        type = lib.types.str;
        default = "UTC";
        description = "Define time zone";
      };

      deviceType = lib.mkOption {
        type = lib.types.enum [
          "unspecified"
          "desktop"
          "laptop"
          "server"
        ];
        default = "unspecified";
        description = "Device on which host resides.";
        example = "server";
      };
    };
  };

  den.aspects.timezone.nixos = {host, ...}: {
    time.timeZone = host.timeZone or "UTC";
  };
}
