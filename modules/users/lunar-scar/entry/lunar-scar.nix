{
  den.hosts.x86_64-linux.nebula.users.lunar-scar = {
    isPrimaryUser = true;
    repoRoot = "/home/lunar-scar/nix-config";

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
          git = let
            username = "abyssal-twilight";
          in {
            inherit username;
            # Tip from: https://docs.codeberg.org/git/configuring-git
            email = "${username}@noreply.codeberg.org";
            signingKey = "A32087F99284F121";
          };

          jujutsu.signing = {
            backend = "gpg";
            key = "A32087F99284F121";
          };
        };

        terminal.kitty.fontFeatures = "VictorMonoNF-Regular +ss08";
        shells.defaultShell = "nushell";
      };
    };
  };
}
