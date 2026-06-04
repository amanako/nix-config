{den, ...}: {
  den.aspects.shell.interpreters.bash = {
    includes = [
      (den.batteries.user-shell "bash")
    ];

    persysUser.directories = [
      ".bash_history"
    ];
  };
}
