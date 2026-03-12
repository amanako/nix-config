{ pkgs, ... }:

let 
	fontName = "Victor Mono Nerd Font";
in
{
  programs.kitty = {
    enable = true;
    themeFile = "GruvboxMaterialDarkHard";
    font = {
      name = fontName;
      package = pkgs.nerd-fonts.victor-mono;
      size = 12;
    };
    enableGitIntegration = true;
    shellIntegration.enableFishIntegration = true;
    settings = {
      window_padding_width = 4;
      hide_window_decorations = true;
      cursor_trail = 1;
			cursor_trail_start_threshold = 2;
			cursor_trail_decay = "0.15 0.3";
			font_features = "VictorMonoNF-Regular +ss08";
			allow_remote_control = "socket-only";
			listen_on = "unix:/tmp/kitty";
		};
  };
}
