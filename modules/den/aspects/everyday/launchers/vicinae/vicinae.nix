{
  den,
  inputs,
  ...
}: {
  flake-file = {
    inputs.vicinae.url = "github:vicinaehq/vicinae";

    nixConfig = {
      extra-substituters = ["https://vicinae.cachix.org"];
      extra-trusted-public-keys = ["vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="];
    };
  };

  den.aspects.everyday.launchers.vicinae = {
    description = "High-performance, native command palette for your desktop.";

    includes = [
      den.aspects.everyday.launchers.conflict-manager
    ];

    persistUser = {
      directories = [
        ".cache/vicinae"
      ];

      files = [
        ".local/state/vicinae/onboarding.json"
      ];
    };

    niriSettings.binds = {
      "Mod+Space".action.spawn-sh = "vicinae toggle";
    };

    stylixHMSettings.targets.vicinae.enable = true;

    hm = {
      pkgs,
      user,
      ...
    }: {
      imports = [
        inputs.vicinae.homeManagerModules.default
      ];

      # Per FAQ: https://docs.vicinae.com/faq#how-to-set-which-terminal-to-use-to-launch-terminal-apps.
      xdg.configFile."xdg-terminals.list".text = "${user.preferences.effective.term}.desktop\n";

      programs.vicinae = {
        enable = true;
        package = pkgs.vicinae;

        systemd = {
          enable = true;
          autoStart = true;

          environment.USE_LAYER_SHELL = 1;
        };

        settings = {
          close_on_focus_loss = true;
          consider_preedit = true;
          pop_to_root_on_close = false;
          search_files_in_root = true;
          font.rendering = "native";

          favicon_service = "google";
        };
      };
    };
  };
}
