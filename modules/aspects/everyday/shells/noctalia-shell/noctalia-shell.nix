{inputs, ...}: {
  imports = [(inputs.den.namespace "noctalia-shell" false)];

  flake-file = {
    inputs.noctalia-shell.url = "github:noctalia-dev/noctalia/legacy-v4";

    nixConfig = {
      extra-substituters = ["https://noctalia.cachix.org"];
      extra-trusted-public-keys = [
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];
    };
  };

  noctalia-shell.entry = {
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
