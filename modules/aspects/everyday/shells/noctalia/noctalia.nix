{
  inputs,
  noctalia,
  ...
}: {
  imports = [(inputs.den.namespace "noctalia" false)];

  flake-file = {
    inputs.noctalia.url = "github:noctalia-dev/noctalia";

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

      This is the new v5 version which is currently in alpha phase.
      It is recommended to use this version.
    '';

    stylixHMSettings.targets."noctalia-shell".enable = false;

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

    niriSpawnAtStartup = {
      command = ["noctalia"];
    };

    hm = {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      programs.noctalia.enable = true;
    };
  };
}
