{
  den.aspects.terminal.zellij = {
    stylixHMSettings.targets."zellij".enable = true;
    # Zellij uses cache folders to revive sessions on reboot or crashes
    persysUser.directories = [
      ".cache/zellij"
    ];

    homeManager.programs.zellij.enable = true;
  };
}
