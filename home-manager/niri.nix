{ pkgs, inputs, config, lib, ... }:

{
  home-manager.users.lunar-scar = {
    imports = [
      inputs.niri.homeModules.niri
    ];

    programs.niri = {
      enable = true;
      package = pkgs.niri;
      settings = {
        #spawn-at-startup = [
        #  {
        #    command = [ "noctalia-shell" ];
        #  }
        #];
	environment = {
          XDG_CURRENT_DESKTOP = "niri";
	  XDG_SESSION_TYPE = "wayland";
	  QT_QPA_PLATFORM = "wayland";
	};

	#binds = with config.lib.niri.actions;
	 # lib.mapAttrs (_: bind: bind // { repeat = lib.mkDefault false; }) {
          #"Mod+Space".action = "qs -c noctalia-shell ipc call launcher toggle";
	  #"Mod+S".action = "qs -c noctalia-shell ipc call controlCenter toggle";
	  #"Mod+Comma".action = "qs -c noctalia-shell ipc call settings toggle";
	 # "Mod+T".action.spawn = kitty;
	#};
      };
    };
  };
  
  systemd.user.services.niri-flake-polkit.enable = false;
}
