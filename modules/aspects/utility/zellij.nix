{
  den.aspects.utility.provides.zellij = {
    stylixHome.targets."zellij".enable = true;
    # Zellij uses cache folders to revive sessions on reboot or crashes
    persysUser.directories = [
      ".cache/zellij"
    ];

    homeManager.programs.zellij = {
      enable = true;
      # themes = "gruvbox-dark";
    };
  };
}
