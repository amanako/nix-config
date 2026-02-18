{
  services = {
    upower.enable = true;
    tuned.enable = true;
    
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
	variant = "";
      };
    };
   
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
	support32Bit = true;
      };
      pulse.enable = true;
    };
  };
}
