{
	i18n.inputMethod.fcitx5.settings = {
		inputMethod = {
			GroupOrder."0" = "Default";
			GroupOrder."1" = "Japanese";
			GroupOrder."2" = "Serbian";
			"Groups/0" = {
				Name = "Default";
				"Default Layout" = "us";
			};
			"Groups/0/Items/0".Name = "keyboard-us";

			"Groups/1" = {
        Name = "Japanese";
				"Default Layout" = "us";
				DefaultIM = "mozc";
			};
			"Groups/1/Items/0".Name = "mozc";

			"Groups/2" = {
				Name = "Serbian";
				"Default Layout" = "keyboard-rs";
			};
			"Groups/2/Items/0".Name = "keyboard-rs";
		};

		globalOptions = {
			EnumerateWithTriggerKeys.enabled = true;
			EnumerateSkipFirst.enabled = true;
			"Hotkey/EnumerateForwardKeys"."0" = "Alt+space";
			"Hotkey/EnumerateBackwardKeys"."0" = "Alt+Shift+space";
			"Hotkey/EnumerateGroupForwardKeys"."0" = "Control+space";
			"Hotkey/EnumerateGroupBackwardKeys"."0" = "Control+Shift+space";
			"Hotkey/NextCandidate"."0" = "Tab";
			"Hotkey/PrevCandidate"."0" = "Shift+Tab";
			Behaviour = {
				ActiveByDefault = true;
				ShareInputState = "Yes";
			};
		};
	};
}
