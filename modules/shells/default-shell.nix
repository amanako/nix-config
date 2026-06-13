{
  inputs,
  den,
  ...
}: {
  imports = [inputs.den.flakeModule];
  den.schema.flake-system.includes = [den.aspects.default-shell];

  den.aspects.default-shell = {
    devShells = {pkgs, ...}: {
      default = pkgs.mkShell {
        packages = [
          pkgs.just
        ];

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
}
