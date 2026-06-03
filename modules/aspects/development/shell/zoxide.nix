{
  den.aspects.shell.zoxide = {user, ...}: {
    persysUser.directories = [
      ".local/share/zoxide" # database for previos entries
    ];

    homeManager.programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
