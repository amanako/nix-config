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
    includes = [
      niri._
      niri.animations._
    ];
  };

  niri.entry = {
    description = ''
      From [description](https://github.com/niri-wm/niri):
      A scrollable-tiling Wayland compositor.

      This is aspect using flake for nix-native setup of niri.
      Reference: https://github.com/sodiboo/niri-flake
    '';

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
      niriSettings,
      inputs',
      lib,
      ...
    }: {
      imports = [inputs.niri.homeModules.niri];
      nixpkgs.overlays = [inputs.niri.overlays.niri];

      programs.niri = let
        niri-pkgs = inputs'.niri-pkgs.packages;
      in {
        enable = true;
        package = niri-pkgs.niri-unstable;
        # Reference: https://github.com/sodiboo/niri-flake/blob/main/docs.md#programsnirisettings
        settings =
          # First parameter represents name of attribute list to use(can be omitted in this case).
          # Second one is list of all elements in this attribute set.
          # Concatenate lists keeping only unique one's and deep merge attribute sets similarly to den's freeform approach.
          niriSettings
          |> lib.zipAttrsWith (
            _: values: let
              allLists =
                values
                |> (builtins.all builtins.isList);
              allAttrs =
                values
                |> (builtins.all builtins.isAttrs);
            in
              if allLists
              then
                values
                |> builtins.concatLists
                |> lib.unique
              else if allAttrs
              then
                values
                |> lib.foldl' lib.recursiveUpdate {}
              else
                values
                |> builtins.head
          )
          |> lib.recursiveUpdate {
            includes = lib.mkAfter [
              ./blur.kdl
            ];
            xwayland-satellite.path =
              niri-pkgs.xwayland-satellite-unstable
              |> lib.getExe;

            animations.slowdown = 1.5;
          };
      };
    };
  };
}
