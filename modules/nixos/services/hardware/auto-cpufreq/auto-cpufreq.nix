{ inputs, ... }:

{
  # GUI app comes included as well
  # Current config is tailored to prioritize powersave while not plugen in
  flake.modules.nixos.auto-cpufreq = {
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
}
