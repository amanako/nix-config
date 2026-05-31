{
  noctalia.settings.systemMonitor = {
    homeManager.programs.noctalia-shell.settings.systemMonitor = {
      cpuWarningThreshold = 80;
      cpuCriticalThreshold = 90;
      tempWarningThreshold = 60;
      tempCriticalThreshold = 80;
      gpuWarningThreshold = 80;
      gpuCriticalThreshold = 90;
      memWarningThreshold = 80;
      memCriticalThreshold = 90;
      swapWarningThreshold = 80;
      swapCriticalThreshold = 90;
      diskWarningThreshold = 80;
      diskCriticalThreshold = 90;
      diskAvailWarningThreshold = 20;
      diskAvailCriticalThreshold = 10;
      batteryWarningThreshold = 20;
      batteryCriticalThreshold = 5;
      enableDgpuMonitoring = false;
      useCustomColors = false;
    };
  };
}
