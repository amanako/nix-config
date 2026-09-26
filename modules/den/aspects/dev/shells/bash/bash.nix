{
  den.aspects.dev.shells.bash = {
    description = "GNU Bourne Again SHell — the classic interactive shell.";

    persistUser.directories = [
      ".bash_history"
    ];

    hm.programs.bash = {
      enable = true;
    };
  };
}
