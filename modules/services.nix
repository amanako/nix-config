{ config, pkgs, ... }:

{
  services = {
    upower.enable = true;
    tuned.enable = true;
    
    xserver = {
      # Enable the X11 windowing system.
      enable = true;

      #Configure keymap in X11
      xkb = {
        layout = "us";
	variant = "";
      };
    };
   
    # Enable sound with pipewire.
    pipewire = {
      enable = true;

      alsa = {
        enable = true;
	support32Bit = true;
      };

      pulse.enable = true;
    };

    greetd = {
      enable = true;
      settings = {
        default_session = {
	  command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd niri-session --remember --remember-session --user-menu";
	  user = "greeter";
	 };
      };
    };
  };
}
