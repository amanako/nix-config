{ pkgs, ... }:

{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
	command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session --remember --remember-session --user-menu --greeting 'Gloominess = chance for a walk'";
        user = "greeter";
      };
    };
  };
} 
