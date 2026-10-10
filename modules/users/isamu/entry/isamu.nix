{
  den.hosts.x86_64-linux.ashikaga.users.isamu = {
    isPrimaryUser = true;
    preferences = {
      browser = "zen-beta";
      term = "kitty";
      editor = "nvim";
      fileManager = "nautilus";

      monofont = {
        package = "nerd-fonts.victor-mono";
        name = "VictorMono Nerd Font";
      };
    };

    settings = {
      niri.binds.keyboard-backlight.device = "backlight:amdgpu_bl1";
      dev.shells.defaultShell = "fish";
      everyday.bars.waybar.location = "Nis";
    };
  };
}
