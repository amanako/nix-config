{
  niri,
  inputs,
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

  niri.full = {
    description = "Full aggregator for the niri Wayland compositor aspects, including all sub-aspects.";

    includes = [
      niri._
      niri.animations._
    ];
  };

  niri.entry = {
    description = ''
      A scrollable-tiling Wayland compositor.

      This is aspect using flake for nix-native setup of niri.
      Reference: https://github.com/sodiboo/niri-flake.
    '';

    includes = [
      niri.niriSettingsCollector
    ];

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

    hm = {
      inputs',
      pkgs,
      ...
    }: {
      imports = [inputs.niri.homeModules.niri];
      nixpkgs.overlays = [inputs.niri.overlays.niri];

      home.packages = [
        pkgs.wl-clipboard
      ];

      programs.niri = {
        enable = true;
        package = inputs'.niri-pkgs.packages.niri-unstable;
      };
    };
  };
}
