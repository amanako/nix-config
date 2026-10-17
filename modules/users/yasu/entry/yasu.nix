{
  den.hosts.x86_64-linux.kusunoki.users.yasu = {
    isPrimaryUser = true;
    repoRoot = "/home/yasu/Dev/Projects/nix-config";

    preferences = {
      editor = "nvim";
      fileManager = "yazi";
      browser = "zen-twilight";
      term = "kitty";

      monofont = {
        package = "nerd-fonts.victor-mono";
        name = "VictorMono Nerd Font";
      };
    };

    settings = {
      niri.binds.keyboard-backlight.device = "asus::kbd_backlight";

      everyday = {
        utility.anki.profileName = "yoha";

        wallpaper-managers.awww = {
          script.args = [
            "--transition-fps 144"
            "--transition-type wave"
            "--transition-angle 225"
            "--resize=fit"
          ];
          script.label = "wallpaper-mix";

          service.calendar = "*-*-* *:00";
        };

        bars.waybar.location = "Nis";
      };

      security.sops-user = {
        ageKeyFile = "keys/age/key.txt";
      };

      dev = {
        shell-tools = {
          git = {
            username = "amanako";
            email = "git@kairi6.anonaddy.com";
            signingKey = "39476BD8508A995B";
          };

          jujutsu.signing = {
            backend = "gpg";
            key = "39476BD8508A995B";
          };
        };

        terminal.kitty.fontOptions.fontFeatures = "VictorMonoNF-Regular +ss08";
        shells.defaultShell = "nushell";
      };
    };
  };
}
