{
	i18n.inputMethod.fcitx5.settings = {
		inputMethod = {
			GroupOrder."0" = "Default";
			"Groups/0" = {
				Name = "Default";
				"Default Layout" = "us";
				DefaultIm = "mozc";
			};
			"Groups/0/Items/0".Name = "keyboard-us";
			"Groups/0/Items/1".Name = "mozc";
		};

		globalOptions = {
			EnumerateWithTriggerKeys = true;
			EnumerateSkipFirst = true;
			ModifierOnlyKeyTimeout = 250;
			"Hotkey/EnumerateForwardKeys"."0" = "Control+Shift";
			"Hotkey/EnumerateBackwardKeys"."0" = "Control+Shift+space";
			"Hotkey/EnumerateGroupForwardKeys"."0" = "Control+Shift";
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
