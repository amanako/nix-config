{ pkgs, inputs, ... }:

{
  home-manager.users.lunar-scar = {
    imports = [
      inputs.niri.homeModules.niri
    ];

    programs.niri = {
      enable = true;
      package = pkgs.niri;
      settings = {
        spawn-at-startup = [
          {
            command = [ "noctalia-shell" ];
          }
        ];
	environment = {
          XDG_CURRENT_DESKTOP = "niri";
	  XDG_SESSION_TYPE = "wayland";
	  QT_QPA_PLATFORM = "wayland";
	};
      };
    };
  };
}
