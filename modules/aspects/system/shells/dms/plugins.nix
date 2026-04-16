{ inputs, ... }:

{
  flake-file.inputs = {
    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.system._.dms.homeManager = {
    imports = [
      inputs.dms-plugin-registry.modules.default
    ];

    programs.dank-material-shell = {
      managePluginSettings = true;

      plugins = {
        dankBatteryAlerts.enable = true;
        dankHooks.enable = true;
        dankActions.enable = true;
        dankPomodoroTimer.enable = true;
      };
    };

    # This plugin won't be included for now for known issues
    #programs.nix-monitor = {
    #  src = lib.mkDefault (
    #    pkgs.fetchFromGitHub {
    #      owner = "antonjah";
    #      repo = "nix-monitor";
    #      rev = "v1.0.3";
    #      sha256 = "sha256-biRc7ESKzPK5Ueus1xjVT8OXCHar3+Qi+Osv/++A+Ls=";
    #    }
    #  );
    #
    #  enable = true;
    #  settings = {
    #    updateInterval = 1200;
    #
    #    rebuildCommand = [
    #      # Delegate task to pkexec since nixos-rebuild requires password
    #      "bash"
    #      "-c"
    #      "TERM=${config.home.sessionVariables.TERM} pkexec nixos-rebuild switch --flake=${config.home.sessionVariables.NH_FLAKE} 2>&1"
    #    ];
    #
    #   gcCommand = [
    #     "bash"
    #      "-c"
    #      "nix-collect-garbage --delete-older-than 4d"
    #    ];
    #
    #    generationsCommand = [
    #      "bash"
    #      "-c"
    # Tip from reddit
    #      ''readlink /nix/var/nix/profiles/system | grep -o "[0-9]*"''
    #    ];

    #    storeSizeCommand = [
    #      "bash"
    #      "-c"
    # The fastest command I could find
    #      "nix path-info --json --all | jq 'map(.narSize) | add' | numfmt --to=iec --suffix=B"
    #    ];

    #    remoteRevisionCommand = [
    #      "bash"
    #      "-l"
    #      "-c"
    # Performance tip from: https://antonjah.github.io/nix-monitor/
    #      "${pkgs.curl}/bin/curl -s https://api.github.com/repos/NixOS/nixpkgs/git/ref/heads/nixos-unstable 2>/dev/null | ${pkgs.jq}/bin/jq -r '.object.sha' 2>/dev/null | cut -c 1-7 || echo 'N/A'"
    #    ];

    #    nixpkgsChannel = "nixos-unstable";

    # };
    #};
  };

}
