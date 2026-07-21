{lib, ...}: {
  flake-file = {
    inputs.llm-agents.url = "github:numtide/llm-agents.nix";

    nixConfig = {
      extra-substituters = ["https://cache.numtide.com"];
      extra-trusted-public-keys = ["niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="];
    };
  };

  den.aspects.dev.terminal.vix = {
    description = "Sleek, Fast and Token Efficient AI Coding Agent";

    persistUser.directories = [
      # Hooks, jobs, config and other
      ".vix"
    ];

    # The `vix` package set ships both the `vix` CLI and the `vixd` daemon.
    # The CLI expects `vixd` to already be running, resulting in error otherwise
    # Create a small systemd service to ensure it runs
    userSettings = {
      runDaemonService = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Whether to run the vixd daemon as a systemd user service after graphical-session.target.";
      };
    };

    hm = {
      user,
      inputs',
      lib,
      config,
      ...
    }: let
      cfg = user.settings.dev.terminal.vix;
      vixPkg = inputs'.llm-agents.packages.vix;
    in {
      home.packages = [
        vixPkg
      ];

      # A service similar to one installed by "vix daemon install" command
      systemd.user.services.vixd = lib.mkIf cfg.runDaemonService {
        Unit = {
          Description = "Vixd - vix daemon start service";
          # Wait for sops-nix to decrypt secrets before starting, otherwise the
          # EnvironmentFile below may not exist yet.
          Requires = ["sops-nix.service"];
          After = ["graphical-session.target" "sops-nix.service"];
        };

        Service = {
          ExecStart = "vixd" |> lib.getExe' vixPkg;
          Restart = "on-failure";
          RestartSec = 2;
          Environment = "VIX_NO_MISSION_CONTROL=1"; # Don't open web UI
          EnvironmentFile =
            config.sops.templates
            |> lib.hasAttr "secrets.env"
            |> (present: lib.mkIf present config.sops.templates."secrets.env".path);
        };

        Install.WantedBy = ["default.target"];
      };
    };
  };
}
