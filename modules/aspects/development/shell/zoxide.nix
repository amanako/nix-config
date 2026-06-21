{
  den.aspects.shell.zoxide = {
    persistUser.directories = [
      ".local/share/zoxide" # database for previous entries
    ];

    homeManager.programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
