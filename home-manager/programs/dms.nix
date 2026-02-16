{ ... } :

{
  programs.dank-material-shell = {
    enable = true;
    niri.enableSpawn = true;

    niri.includes = {
      enable = true;
      override = true;
      originalFileName = "hm";
    
      filesToInclude = [
        "alttab"
        "binds"
        "colors"
        "layout"
        "outputs"
        "wpblur"
	"cursor"
      ];
    };

    managePluginSettings = true;
    
    plugins = {
      dankBatteryAlerts.enable = true;
      mediaPlayer.enable = true;
      desktopCommand.enable = true;
    };
  };
}
