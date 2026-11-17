{
  niri.environment = {
    # Variables to initialize wayland - will likely crash otherwise
    niriSettings.environment = {
      XDG_CURRENT_DESKTOP = "niri";
      XDG_SESSION_TYPE = "wayland";
      QT_QPA_PLATFORM = "wayland";
    };
  };
}
