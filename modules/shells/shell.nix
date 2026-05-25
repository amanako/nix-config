{
  inputs,
  den,
  ...
}: {
  imports = [inputs.den.flakeModule];

  den.aspects.default-shell = {
    persysUser.directories = [
      # Direnv allow directory persistence
      ".local/share/direnv/allow"
      # Cache for installed hooks
      ".cache/pre-commit"
    ];

    homeManager.programs.direnv = {
      enable = true;
      enableFishIntegration = true;
      nix-direnv.enable = true;
      silent = true;
    };

    devShells = {pkgs, ...}: {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [
          pre-commit
          woodpecker-cli
          alejandra
          stylua
          luaPackages.luacheck
          nodejs
          prettier
          markdown-toc
          mdformat
        ];

        shellHook = ''
          echo "Welcome to my nix-config repo!"
          export PRE_COMMIT_HOME=$HOME/.cache/pre-commit
          # For pre commit to use pure nix packages instead of downloading
          export PRE_COMMIT_USE_NIX=1
        '';
      };
    };
  };

  den.schema.flake-system.includes = [den.aspects.default-shell];
}
