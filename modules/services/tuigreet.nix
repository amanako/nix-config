{ pkgs, ... }:

{
  services.greetd = {
    enable = true;
    settings = {
        default_session = {
	command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session --remember --remember-session --user-menu";
        user = "greeter";
      };
    };
  };
} 
