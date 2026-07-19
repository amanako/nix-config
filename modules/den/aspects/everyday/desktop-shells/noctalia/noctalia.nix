{
  den,
  inputs,
  noctalia,
  ...
}: {
  imports = [(inputs.den.namespace "noctalia" false)];

  flake-file = {
    # Following cachix branch ensures latest *cached* build is used.
    # This may cause a little lag behind main, but it should be a negligible difference.
    inputs.noctalia.url = "github:noctalia-dev/noctalia/cachix";

    nixConfig = {
      extra-substituters = ["https://noctalia.cachix.org"];
      extra-trusted-public-keys = [
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];
    };
  };

  noctalia.full = {
    includes = [
      noctalia._
      noctalia.niri
      noctalia.settings._
    ];
  };

  noctalia.entry = {
    description = ''
      From [description](https://github.com/noctalia-dev/noctalia):
      A sleek and minimal desktop shell thoughtfully crafted for Wayland.

      This is the new v5 version which is currently in beta phase.
      It is recommended to use this version.
    '';

    # Don't enable bar for users who don't include corresponding aspect
    includes = [
      (
        den.lib.policy.when ({user, ...}: !user.hasAspect noctalia.bar) {
          hm.programs.noctalia.settings.bar.default.enabled = false;
        }
      )
    ];

    stylixHMSettings.targets."noctalia".enable = false;

    persistUser = {
      directories = [
        ".local/state/noctalia/clipboard"
      ];

      files = [
        ".local/state/noctalia/.setup-complete"
        ".local/state/noctalia/screen_time.json"

        ".cache/noctalia/location.json"
        ".cache/noctalia/shell-state.json"
        ".cache/noctalia/weather.json"
      ];
    };

    hm = {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      programs.noctalia.enable = true;
    };
  };
}
