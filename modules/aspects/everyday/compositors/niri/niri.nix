{
  inputs,
  __findFile,
  ...
}: {
  imports = [(inputs.den.namespace "niri" false)];

  flake-file = {
    inputs = {
      # Current workaround for blur: https://github.com/sodiboo/niri-flake/issues/1721
      niri.url = "github:sodiboo/niri-flake/very-refactor";
      niri-pkgs.url = "github:sodiboo/niri-flake";
    };

    nixConfig = {
      extra-substituters = ["https://niri.cachix.org"];
      extra-trusted-public-keys = ["niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="];
    };
  };

  den.quirks.niriSpawnAtStartup = {
    description = ''
      Programs to spawn alongside niri.
    '';
  };

  niri.entry = {
    description = ''
      From [description](https://github.com/niri-wm/niri):
      A scrollable-tiling Wayland compositor.

      This is aspect using flake for nix-native setup of niri.
      Reference: https://github.com/sodiboo/niri-flake
    '';

    niriSettings = {};

    nixos = {inputs', ...}: {
      systemd.user.services.niri-flake-polkit.enable = false;
      nixpkgs.overlays = [inputs.niri-pkgs.overlays.niri];
      # Necessary for niri to be enabled via nixos class.
      # This helps since it can be caught by display managers.
      # Also match nixos and home-manager versions.
      programs.niri = {
        enable = true;
        package = inputs'.niri-pkgs.packages.niri-unstable;
      };
    };

    homeManager = {
      niriSpawnAtStartup,
      inputs',
      lib,
      ...
    }: {
      imports = [inputs.niri.homeModules.niri];
      nixpkgs.overlays = [inputs.niri.overlays.niri];

      programs.niri = {
        enable = true;
        package = inputs'.niri-pkgs.packages.niri-unstable;
        # Reference: https://github.com/sodiboo/niri-flake/blob/main/docs.md#programsnirisettings
        settings = {
          includes = lib.mkAfter [
            ./blur.kdl
          ];

          spawn-at-startup = niriSpawnAtStartup;
          animations.slowdown = 1.5;
        };
      };
    };
  };
}
