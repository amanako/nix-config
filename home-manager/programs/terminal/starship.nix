{ lib, ... }:

{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
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

      palette = "gruvbox_dark";

      palettes.gruvbox_dark = {
        color_blue = "#458588";
        color_aqua = "#689d6a";
        color_green = "#98971a";
        color_orange = "#d65d0e";
        color_purple = "#b16286";
        color_red = "#cc241d";
        color_yellow = "#d79921";
      };

      directory = {
        style = "color_orange";
      };

      git_branch = {
        symbol = "";
        style = "color_aqua";
        format = "[[ $symbol $branch ](color_blue color_aqua)]($style)";
      };

      git_status = {
        style = "color_aqua";
        format = "[[($all_status$ahead_behind )](color_orange colow_yellow)]($style)";
      };

      character = {
        success_symbol = "[ ](bold color_green)";
        error_symbol = "[ ](bold color_red)";
        vimcmd_symbol = "[ ](bold color_purple)";
      };

      cmd_duration = {
        format = "[$duration]($style) ";
      };
    };
  };
}
