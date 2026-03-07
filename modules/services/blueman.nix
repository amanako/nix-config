{ lib, hardware, ... }:

let
	bluemanEnable = lib.mkOptions {
		default = hardware.bluetooth.enable;
		type = lib.types.bool;
		description = "Whether to enable blueman, a bluetooth manager";
	};
in
{
	services.blueman.enable = bluemanEnable;
}
