{
  den.aspects.dev.shell-tools.direnv = {
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
