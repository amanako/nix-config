{
  den.aspects.dev.shell-tools.direnv = {
    description = "Environment variable loader that augments your shell with per-directory profiles.";

    persistUser.directories = [
      # Direnv allow directory persistence.
      ".local/share/direnv/allow"
      # Cache for installed hooks.
      ".cache/pre-commit"
    ];

    hm.programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      silent = true;
    };
  };
}
