{
  den.hosts.x86_64-linux.ashikaga.users.isamu = {
    isPrimaryUser = true;
    preferences = {
      browser = "zen-beta";
      term = "kitty";
      editor = "nvim";
      fileManager = "yazi";

      monofont = {
        package = "nerd-fonts.victor-mono";
        name = "VictorMono Nerd Font";
      };
    };

    settings = {
      niri.binds.keyboard-backlight.device = "backlight:amdgpu_bl1";
      dev.shells.defaultShell = "fish";
      dev.terminal.kitty.fontOptions.fontFeatures = "VictorMonoNF-Regular +ss08";
      everyday.bars.waybar.location = "Nis";

      everyday.wallpaper-managers.awww = {
        script.args = [
          "--transition-fps 60"
          "--transition-type simple"
          "--resize=fit"
        ];
      };

      dev.shell-tools.git = {
        username = "IRefactoredThat";
        email = "nikola.l.savic@protonmail.com";
        signingKey = "476A11B36C1F3A7B";
      };
    };
  };
}
