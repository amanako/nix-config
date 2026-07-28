{
  den.aspects.dev.shell-tools.bat = {
    description = "A cat(1) clone with syntax highlighting and Git integration.";

    hm = {
      pkgs,
      lib,
      ...
    }: {
      programs.bat = {
        enable = true;
        config = {
          theme = lib.mkDefault "ansi";
          style = "full";
          italic-text = "always";
        };
        extraPackages = with pkgs.bat-extras; [
          # Integration for various programs
          core
        ];
      };
    };
  };
}
