{ inputs, ... }:
{
	imports = [ inputs.dms-plugin-registry.modules.default ];

	programs.dank-material-shell.plugins = {
		dankBatteryAlerts.enable = true;
		nixMonitor.enable = true;
		desktopCommand.enable = true;
	};
}
