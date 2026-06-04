{
  den.aspects.shell.interpreters.nu.entry = {user, ...}: {
    persysUser.directories = [
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
