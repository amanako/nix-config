{inputs, ...}: {
  imports = [(inputs.den.namespace "noctalia-shell" false)];

  flake-file = {
    inputs.noctalia-shell.url = "github:noctalia-dev/noctalia/f816591afc2f2f606d1f0cf70b51e95c04a7a8aa";

    nixConfig = {
      extra-substituters = ["https://noctalia.cachix.org"];
      extra-trusted-public-keys = [
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];
    };
  };

  noctalia-shell.entry = {
    description = ''
      From [description](https://github.com/noctalia-dev/noctalia):
      A sleek and minimal desktop shell thoughtfully crafted for Wayland.

      This is legacy version 4 from branch legacy-v4 of repo.
      It is recommended to try out new v5 alpha from noctalia aspect.
    '';

    stylixHMSettings.targets."noctalia-shell".enable = false;

    persistsUser.files = [".cache/noctalia/shell-state.json"];

    hm = {
      imports = [
        inputs.noctalia-shell.homeModules.default
      ];

      programs.noctalia-shell.enable = true;
    };
  };
}
