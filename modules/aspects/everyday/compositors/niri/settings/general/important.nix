{
  niri.important.homeManager = {
    inputs',
    lib,
    ...
  }: {
    programs.niri.settings = {
      # Important variables to initialize wayland - will likely crash otherwise
      environment = {
        XDG_CURRENT_DESKTOP = "niri";
        XDG_SESSION_TYPE = "wayland";
        QT_QPA_PLATFORM = "wayland";
      };

      # For compatibility with various X11-based programs while running niri
      xwayland-satellite.path = lib.getExe inputs'.niri-pkgs.packages.xwayland-satellite-unstable;
    };
  };
}
