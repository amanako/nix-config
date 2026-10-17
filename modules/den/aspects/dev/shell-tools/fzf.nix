{
  den.aspects.dev.shell-tools.fzf = {
    description = "A general-purpose command-line fuzzy finder.";

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
        inherit defaultCommand;
        fileWidget.command = defaultCommand;
        defaultOptions = [
          "--ansi"
          "--border"
        ];
      };
    };
  };
}
