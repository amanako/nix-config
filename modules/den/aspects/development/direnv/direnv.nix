{den, ...}: {
  den.aspects.direnv-for-users = {
    persistUser.directories = [
      # Direnv allow directory persistence
      ".local/share/direnv/allow"
      # Cache for installed hooks
      ".cache/pre-commit"
    ];

    hm = {
      user,
      lib,
      ...
    }: {
      programs.direnv =
        {
          enable = true;
          nix-direnv.enable = true;
          silent = true;
        }
        // lib.optionalAttrs (user.hasAspect den.aspects.shell.interpreters.fish) {
          enableFishIntegration = true;
        }
        // lib.optionalAttrs (user.hasAspect den.aspects.shell.interpreters.nu) {
          enableNushellIntegration = true;
        };
    };
  };

  den.schema.user.includes = [den.aspects.direnv-for-users];
}
