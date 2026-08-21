{den, ...}: {
  den.aspects.core.flatpaks.sober = {
    description = ''
      Sober - a native Linux port for playing Roblox via Flatpak.
      Developed by VinegarHQ, it runs the Android Roblox client without Wine or emulators.
    '';

    includes = [
      den.aspects.core.flatpaks
    ];

    # Fix unable to move in first-person games due to x11 input
    # Reference: https://github.com/vinegarhq/sober/issues/1356#issuecomment-3765883022
    nushellConfig = ''
      $env.GDK_BACKEND = "wayland"
      $env.SDL_VIDEODRIVER = "wayland"
      $env.CLUTTER_BACKEND = "wayland"
    '';

    hm = {
      services.flatpak.packages = [
        "flathub:app/org.vinegarhq.Sober//stable"
      ];

      home.sessionVariables = {
        GDK_BACKEND = "wayland";
        SDL_VIDEODRIVER = "wayland";
        CLUTTER_BACKEND = "wayland";
      };
    };
  };
}
