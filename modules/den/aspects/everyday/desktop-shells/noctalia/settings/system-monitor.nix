{
  noctalia.settings.systemMonitor = {
    hm.programs.noctalia.settings.system.monitor = {
      enabled = true;
      cpu_poll_seconds = 2.0;
      gpu_poll_seconds = 5.0;
      memory_poll_seconds = 2.0;
      network_poll_seconds = 3.0;
      disk_poll_seconds = 10.0;

      cpu_usage_activity_threshold = 80;
      cpu_usage_critical_threshold = 90;
      cpu_temp_activity_threshold = 60;
      cpu_temp_critical_threshold = 80;
      gpu_temp_activity_threshold = 80;
      gpu_temp_critical_threshold = 90;
      gpu_usage_activity_threshold = 80;
      gpu_usage_critical_threshold = 90;
      ram_pct_activity_threshold = 80;
      ram_pct_critical_threshold = 90;
      swap_pct_activity_threshold = 80;
      swap_pct_critical_threshold = 90;
      disk_used_pct_activity_threshold = 80;
      disk_used_pct_critical_threshold = 90;
      disk_free_pct_activity_threshold = 80;
      disk_free_pct_critical_threshold = 90;
    };
  };
}
