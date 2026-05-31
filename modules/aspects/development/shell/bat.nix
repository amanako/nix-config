{
  den.aspects.shell.bat = {
    homeManager = {
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
