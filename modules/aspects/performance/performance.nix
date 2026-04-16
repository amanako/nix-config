{
  den.aspects.performance = {
    nixos = {
      services.upower.enable = true;
      services.thermald.enable = true;
      services.auto-cpufreq = {
        enable = true;
        settings = {
          battery = {
            governor = "powersave";
            energy_performance_preference = "power";
            platform_profile = "balanced";
            turbo = "never";

            enable_thresholds = true;
            stop_threshold = 90;
          };
          charger = {
            governor = "performance";
            energy_performance_preference = "performance";
            platform_profile = "performance";
            turbo = "auto";
          };
        };
      };
    };
  };
}
