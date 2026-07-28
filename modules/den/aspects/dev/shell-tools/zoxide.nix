{
  den.aspects.dev.shell-tools.zoxide = {
    description = "A smarter cd command that learns your habits and remembers your favourite directories.";

    persistUser.directories = [
      ".local/share/zoxide" # database for previous entries
    ];

    hm.programs.zoxide.enable = true;
  };
}
