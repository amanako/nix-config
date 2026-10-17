{
  den.aspects.dev.shell-tools.starship = {
    description = "The minimal, blazing-fast, and infinitely customizable prompt for any shell.";

    hm = {lib, ...}: {
      programs.starship = {
        enable = true;
        settings = {
          "$schema" = "https://starship.rs/config-schema.json";

          format = lib.concatStrings [
            "$username"
            "$hostname"
            "$directory"
            "$git_branch"
            "$git_state"
            "$git_status"
            "$cmd_duration"
            "$line_break"
            "$character"
          ];

          directory = {
            style = "orange";
          };

          git_branch = {
            symbol = "";
            style = "cyan";
            format = "[[ $symbol $branch ](blue cyan)]($style)";
          };

          git_status = {
            style = "cyan";
            format = "[[($all_status$ahead_behind )](orange yellow)]($style)";
          };

          character = {
            success_symbol = "[ ](bold green)";
            error_symbol = "[ ](bold red)";
            vimcmd_symbol = "[ ](bold purple)";
          };

          cmd_duration = {
            format = "[$duration]($style) ";
          };
        };
      };
    };
  };
}
