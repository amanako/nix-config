{
  den.aspects.shell.zoxide = {user, ...}: {
    persysUser.directories = [
      ".local/share/zoxide" # database for previous entries
    ];

    homeManager.programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
