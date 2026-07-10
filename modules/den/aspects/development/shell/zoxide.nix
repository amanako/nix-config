{
  den.aspects.shell.zoxide = {
    persistUser.directories = [
      ".local/share/zoxide" # database for previous entries
    ];

    hm.programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
