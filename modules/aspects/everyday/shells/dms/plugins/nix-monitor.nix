{
  dms.plugins.nix-monitor = {
    homeManager = {
      user,
      pkgs,
      lib,
      ...
    }: {
      # This plugin won't be included for now for known issues
      programs.nix-monitor = {
        src = lib.mkDefault (
          pkgs.fetchFromGitHub {
            owner = "antonjah";
            repo = "nix-monitor";
            rev = "v1.0.3";
            sha256 = "sha256-biRc7ESKzPK5Ueus1xjVT8OXCHar3+Qi+Osv/++A+Ls=";
          }
        );

        enable = true;
        settings = {
          updateInterval = 1200;

          rebuildCommand = [
            # Delegate task to pkexec since nixos-rebuild requires password
            "bash"
            "-c"
            "TERM=${user.preferences.term} pkexec nixos-rebuild switch --flake=${user.repoRoot} 2>&1"
          ];

          gcCommand = [
            "bash"
            "-c"
            "nix-collect-garbage --delete-older-than 4d"
          ];

          generationsCommand = [
            "bash"
            "-c"
            #Tip from reddit
            ''readlink /nix/var/nix/profiles/system | grep -o "[0-9]*"''
          ];

          storeSizeCommand = [
            "bash"
            "-c"
            #The fastest command I could find
            "nix path-info --json --all | jq 'map(.narSize) | add' | numfmt --to=iec --suffix=B"
          ];

          remoteRevisionCommand = [
            "bash"
            "-l"
            "-c"
            #Performance tip from: https://antonjah.github.io/nix-monitor/
            "${pkgs.curl}/bin/curl -s https://api.github.com/repos/NixOS/nixpkgs/git/ref/heads/nixos-unstable 2>/dev/null | ${pkgs.jq}/bin/jq -r '.object.sha' 2>/dev/null | cut -c 1-7 || echo 'N/A'"
          ];

          nixpkgsChannel = "nixos-unstable";
        };
      };
    };
  };
}
