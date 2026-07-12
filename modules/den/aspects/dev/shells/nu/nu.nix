{
  den.aspects.dev.shells.nu = {
    persistUser.directories = [
      ".config/nu/history.txt"
    ];

    user = {pkgs, ...}: {
      shell = pkgs.nushell;
    };

    hm = {
      programs = {
        nushell.enable = true;
        direnv.enableNushellIntegration = true;
        eza.enableNushellIntegration = true;
        yazi.enableNushellIntegration = true;
      };
    };
  };
}
