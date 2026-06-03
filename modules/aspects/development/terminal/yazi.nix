{inputs, ...}: {
  flake-file = {
    inputs.yazi.url = "github:sxyazi/yazi";

    nixConfig = {
      extra-substituters = ["https://yazi.cachix.org"];
      extra-trusted-public-keys = ["yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="];
    };
  };

  den.aspects.terminal.yazi = {user, ...}: {
    stylixHome.targets."yazi".enable = false;

    homeManager = {
      nixpkgs.overlays = [
        inputs.yazi.overlays.default
      ];
      programs.yazi = {
        enable = true;
        enableFishIntegration = true;
        shellWrapperName = "y";
        keymap = {
          mgr.prepend_keymap = [];
        };
        settings = {
          mgr = {
            show_hidden = false;
          };
          opener.edit = [
            {
              run = "nvim \"$@\"";
              block = true;
            }
          ];
        };
      };
    };
  };
}
