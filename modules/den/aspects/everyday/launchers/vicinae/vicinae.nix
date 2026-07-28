{
  den,
  inputs,
  lib,
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

    persistUser.directories = [
      ".cache/vicinae"
    ];

    niriSettings.binds = {
      "Mod+Space".action.spawn-sh = "vicinae toggle";
    };

    stylixHMSettings.targets.vicinae.enable = true;

    conflicts.warnings = [
      ({user, ...}:
        lib.optional (user.hasAspect den.ful.noctalia.niri) {
          subject = ["everyday.launchers.vicinae"];
          target = ["den.ful.noctalia"];
          message = {
            subject,
            target,
            ...
          }: "${lib.concatStringsSep ", " subject} replaces ${lib.concatStringsSep ", " target} launcher (Mod+Space).";
        })
    ];

    hm = {
      pkgs,
      user,
      ...
    }: {
      imports = [
        inputs.vicinae.homeManagerModules.default
      ];

      # Per FAQ: https://docs.vicinae.com/faq#how-to-set-which-terminal-to-use-to-launch-terminal-apps.
      xdg.configFile."xdg-terminals.list".text = "${user.preferences.term}.desktop\n";

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
