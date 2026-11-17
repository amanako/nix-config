{
  niri,
  inputs,
  ...
}: {
  imports = [(inputs.den.namespace "niri" false)];

  flake-file = {
    inputs.niri.url = "github:epireyn/niri-flake";

    nixConfig = {
      extra-substituters = ["https://niri-epireyn.cachix.org"];
      extra-trusted-public-keys = ["niri-epireyn.cachix.org-1:tlVyFN7CtsDT+ZcLPS+ekFWeT1X6X4OqvWqbBMyIzFA="];
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
      nixpkgs.overlays = [inputs.niri.overlays.niri];
      # Necessary for niri to be enabled via nixos class.
      # This helps since it can be caught by display managers.
      # Also match nixos and home-manager versions.
      programs.niri = {
        enable = true;
        package = inputs'.niri.packages.niri-unstable;
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
        package = inputs'.niri.packages.niri-unstable;
      };
    };
  };
}
