{inputs, ...}: {
  flake-file = {
    inputs.yazi.url = "github:sxyazi/yazi";

    nixConfig = {
      extra-substituters = ["https://yazi.cachix.org"];
      extra-trusted-public-keys = ["yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="];
    };
  };

  den.aspects.dev.terminal.yazi = {
    # system library. This mirrors nixpkgs' own yazi-unwrapped.
    description = "Blazing-fast terminal file manager written in Rust.";

    hm = {
      nixpkgs.overlays = [
        inputs.yazi.overlays.default
        (final: prev: {
          yazi-unwrapped = prev.yazi-unwrapped.overrideAttrs (old: {
            nativeBuildInputs = old.nativeBuildInputs ++ [final.pkg-config];
            buildInputs = old.buildInputs ++ [final.oniguruma];
          });

          # Rebuild the wrapper around the fixed package.
          yazi = prev.yazi.override {yazi-unwrapped = final.yazi-unwrapped;};
        })
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
