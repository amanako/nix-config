{ config, pkgs, ... }:

{
  services = {
    upower.enable = true;
    tuned.enable = true;
    
    xserver = {
      # Enable the X11 windowing system.
      enable = true;

      # Enable GNOME desktop environment;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;

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
  };
  #security.rtkit.enable = true;
}
