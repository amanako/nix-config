{ inputs, lib, pkgs, ... }:

{
  force = true;

	packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
	  darkreader
		proton-pass
		vimium-c
		ublock-origin
		addy_io
	];

	settings = {
		"uBlock0@raymondhill.net".settings = {
		  userSettings = {
				uiTheme = "dark";
				cloudStorageEnabled = lib.mkForce false;
			};
			selectedFilterLists = [
				"ublock-filters"
         "ublock-badware"
				"ublock-privacy"
				"ublock-quick-fixes"
				"plowe-0"
				"easyprivacy"
				"fanboy-cookiemonster"
				"ublock-cookies-easylist"
				"fanboy-social"
				"ublock-annoyances"
			];
		};
		
    "addon@darkreader.org".settings = {
      syncSettings = true;
	  };
  };
}
