{den, ...}: {
  den.aspects.shell.interpreters.bash = {
    includes = [
      (den.batteries.user-shell "bash")
    ];

    persistUser.directories = [
      ".bash_history"
    ];
  };
}
