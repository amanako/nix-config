{ lib, config, ... }:

{
	config.lib.mkIf = config.bluemanEnable {
		services.blueman.enable = true;
	};

	options.bluemanEnable = lib.mkOption {
		default = config.hardware.bluetooth.enable;
		type = lib.types.bool;
		description = "Whether to enable blueman, a bluetooth manager";
	};
}
