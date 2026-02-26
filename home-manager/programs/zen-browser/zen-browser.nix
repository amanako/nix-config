{ inputs, pkgs, ... }:

{
	imports = [ inputs.zen-browser.homeModules.beta ];

	programs.zen-browser = {
		enable = true;
		suppressXdgMigrationWarning = true;
		policies = {
			AutofillAddressEnabled = false;
			AutofillCreditCardEnabled = false;
			DisableFeedbackCommands = true;
			DisableFirefoxStudies = true;
			DisablePocket = true;
			DisableTelemetry = true;
			DontCheckDefaultBrowser = true;
			NoDefaultBookmarks = true;
			OfferToSaveLogins = false;
			EnableTrackingProtection = {
				Value = true;
				Locked = true;
				Cryptomining = true;
				Fingerprinting = true;
			};
		};

		profiles."*" = {
			extensions.packages = 
				with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
			  	darkreader
					proton-pass
					yomitan
					vimium-c
				];

			mods = [
				"f4866f39-cfd6-4498-ab92-54213b8279dc"
			];

			search = {
				force = true;
        default = "ddg"; 
        engines = {
         mynixos = {
            name = "My NixOS";
            urls = [
              {
                template = "https://mynixos.com/search?q={searchTerms}";
                params = [
                  {
                    name = "query";
                    value = "searchTerms";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@nx"];
          };
        };
			};
		};
	};
}
