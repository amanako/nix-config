{inputs, ...}: {
  flake-file = {
    inputs.yazi.url = "github:sxyazi/yazi";

    nixConfig = {
      extra-substituters = ["https://yazi.cachix.org"];
      extra-trusted-public-keys = ["yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="];
    };
  };

  den.aspects.dev.terminal.yazi = {
    stylixHMSettings.targets."yazi".enable = false;

    hm = {
      nixpkgs.overlays = [
        inputs.yazi.overlays.default
      ];

      programs.yazi = {
        enable = true;
        shellWrapperName = "y";
        keymap = {
          mgr.prepend_keymap = [];
        };

        settings = {
          mgr = {
            ratio = [
              1
              3
              4
            ];
            show_hidden = false;
          };
        };
      };
    };
  };
}
