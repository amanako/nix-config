{ inputs, ... }:

{
  flake.hmModules.dms-plugins =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      nh = lib.getExe pkgs.nh;
    in
    {
      imports = [
        inputs.dms-plugin-registry.modules.default
        inputs.nix-monitor.homeManagerModules.default
      ];

      programs.dank-material-shell.plugins = {
        dankBatteryAlerts = {
          enable = true;

          # Access other elements within same attribute set
          settings = rec {
            enableCriticalAlert = true;
            criticalThreshold = "10";
            warningThreshold = "15";

            warningTitle = "Significant drop in battery level";
            warningMessage = "${warningThreshold}% - Careful.";

            criticalTitle = "Critical battery level!";
            criticalMessage = "${criticalThreshold}% - Watch out!";
          };
        };
      };

      # Standalone version appears to be working
      programs.nix-monitor = {
        enable = true;
        updateInterval = 1200;

        # TODO: remove hardcoding
        rebuildCommand = [
          # Delegate task to pkexec since nixos-rebuild requires password
          "bash"
          "-c"
          "TERM=${config.home.sessionVariables.TERM} pkexec nixos-rebuild switch --flake=${config.home.sessionVariables.NH_FLAKE} 2>&1"
        ];

        gcCommand = [
          "bash"
          "-c"
          "nix-collect-garbage --delete-older-than 4d"
        ];

        generationsCommand = [
          "bash"
          "-c"
          # Only count lines which begin with a number
          # nix-env requires root so I wouldn't use it
          ''${nh} os info | grep -E "^[0-9]+" | wc -l''
        ];

        storeSizeCommand = [
          "bash"
          "-c"
          # The fastest command I could find
          "nix path-info --json --all | jq 'map(.narSize) | add' | numfmt --to=iec --suffix=B"
        ];

        remoteRevisionCommand = [
          "bash"
          "-l"
          "-c"
          # Performance tip from: https://antonjah.github.io/nix-monitor/
          "${pkgs.curl}/bin/curl -s https://api.github.com/repos/NixOS/nixpkgs/git/ref/heads/nixos-unstable 2>/dev/null | ${pkgs.jq}/bin/jq -r '.object.sha' 2>/dev/null | cut -c 1-7 || echo 'N/A'"
        ];

        nixpkgsChannel = "nixos-unstable";
      };

    };
}
