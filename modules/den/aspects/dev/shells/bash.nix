{den, ...}: {
  den.aspects.dev.shells.bash = {
    includes = [
      (den.batteries.user-shell "bash")
    ];

    persistUser.directories = [
      ".bash_history"
    ];
  };
}
