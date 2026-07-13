{den, ...}: {
  den.aspects.dev.shell-tools.direnv = {
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
        // lib.optionalAttrs (user.hasAspect den.aspects.dev.shells.fish) {
          enableFishIntegration = true;
        }
        // lib.optionalAttrs (user.hasAspect den.aspects.dev.shells.nu) {
          enableNushellIntegration = true;
        };
    };
  };
}
