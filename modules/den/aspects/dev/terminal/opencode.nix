{
  den.aspects.dev.terminal.opencode = {
    description = "The open source AI coding agent.";

    persistUser.directories = [
      ".local/share/opencode"
      ".local/state/opencode"
    ];

    hm = {pkgs, ...}: {
      home.packages = [
        pkgs.opencode
      ];
    };
  };
}
