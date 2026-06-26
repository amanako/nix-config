{
  den.aspects.shell.fzf = {
    # Stylix colors for fzf aren't really appealing
    stylixHMSettings.targets."fzf".enable = false;

    nixos.programs.fzf.fuzzyCompletion = true;

    hm = {
      pkgs,
      lib,
      ...
    }: {
      programs.fzf = let
        # Rust implementation for find command to improve performance
        fd = lib.getExe pkgs.fd;
        defaultCommand = "${fd} --type file --follow --hidden --exclude .git";
      in {
        enable = true;
        # Enables the following
        # <C-t> = fzf select
        # <C-r> = fzf history
        # Alt-c = fzf cd
        enableFishIntegration = true;
        inherit defaultCommand;
        fileWidgetCommand = defaultCommand;
        defaultOptions = [
          "--ansi"
          "--border"
        ];
        colors = lib.mkDefault {
          fg = "#d4be98";
          bg = "#282626";

          hl = "#d3869b"; # magenta highlight (matches your accents)

          "fg+" = "#d4be98";
          "bg+" = "#32302f"; # selection background
          "hl+" = "#e78a4e"; # stronger highlight (orange)

          info = "#89b482"; # cyan-ish info line
          prompt = "#7daea3"; # blue prompt
          pointer = "#ea6962"; # red pointer (nice contrast)
          marker = "#a9b665"; # green multi-select
          spinner = "#d8a657"; # yellow spinner
          header = "#d3869b"; # magenta header
        };
      };
    };
  };
}
