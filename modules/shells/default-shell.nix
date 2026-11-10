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
        packages = with pkgs; [
          alejandra
          git
          just
          luaPackages.luacheck
          markdown-toc
          mdformat
          nh
          nixd
          nodejs
          pre-commit
          prettier
          python3
          stylua
          woodpecker-cli
        ];

        shellHook = ''
          export PRE_COMMIT_HOME=$HOME/.cache/pre-commit
          # For pre commit to use pure nix packages instead of downloading
          export PRE_COMMIT_USE_NIX=1
        '';
      };
    };
  };
}
