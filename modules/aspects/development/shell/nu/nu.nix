{
  den.aspects.shell.interpreters.nu.entry = {
    persistUser.directories = [
      ".config/nu/history.txt"
    ];

    user = {pkgs, ...}: {
      shell = pkgs.nushell;
    };

    homeManager = {
      programs = {
        nushell.enable = true;
        direnv.enableNushellIntegration = true;
        eza.enableNushellIntegration = true;
        yazi.enableNushellIntegration = true;
      };
    };
  };
}
