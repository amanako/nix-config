{
  den.aspects.dev.shells.nushell = {
    persistUser.directories = [
      ".config/nu/history.txt"
    ];

    hm.programs = {
      nushell.enable = true;
      direnv.enableNushellIntegration = true;
      eza.enableNushellIntegration = true;
      yazi.enableNushellIntegration = true;
    };
  };
}
