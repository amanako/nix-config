{ inputs, config, pkgs, ... }:

{
	imports = [ inputs.zen-browser.homeModules.beta ];

	programs.zen-browser = {
		enable = true;
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
					ublock-origin
					addy_io
				];

			settings = {
				"browser.warnOnClose" = false;
				"browser.warnOnQuit" = false;
				"font.cjk_pref_fallback_order" = "ja,zh-cn,zh-hk,zh-tw,ko";
				"services.sync.engine.addons" = false;
				"services.sync.engine.addresses" = false;
				"services.sync.engine.bookmarks" = false;
				"services.sync.engine.credicards" = false;
				"services.sync.engine.passwords" = false;
				"services.sync.engine.history" = true;
				"services.sync.engine.prefs" = true;
				"services.sync.engine.tabs" = true;
				"services.sync.engine.workspaces" = true;
				"zen.window-sync.enabled" = false;
			};

			containersForce = true;
      containers = {
        Personal = {
          color = "purple";
          icon = "fingerprint";
          id = 1;
        };
        College = {
          color = "orange";
          icon = "briefcase";
          id = 2;
        };
        JP = {
          color = "green";
          icon = "gift";
          id = 3;
        };
      };
      spacesForce = true;
      spaces = let
        containers = config.programs.zen-browser.profiles."*".containers;
      in {
        "Personal" = {
          id = "c6de089c-410d-4206-961d-ab11f988d40a";
					icon = "🧩";
					container = containers."Personal".id;
          position = 1000;
        };
        "College" = {
          id = "cdd10fab-4fc5-494b-9041-325e5759195b";
					icon = "👜";
          container = containers."College".id;
          position = 2000;
        };
        "JP" = {
          id = "78aabdad-8aae-4fe0-8ff0-2a0c6c4ccc24";
          icon = "🈳";
          container = containers."JP".id;
          position = 3000;
        };
      };

			keyboardShortcuts = [ ];

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
