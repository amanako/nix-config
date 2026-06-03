{inputs, ...}: {
  imports = [(inputs.den.namespace "noctalia" false)];

  flake-file = {
    inputs.noctalia.url = "github:noctalia-dev/noctalia-shell";

    nixConfig = {
      extra-substituters = ["https://noctalia.cachix.org"];
      extra-trusted-public-keys = [
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];
    };
  };

  noctalia.entry = {user, ...}: {
    stylixHome.targets."noctalia-shell".enable = false;

    # TODO: Look into reason why this only works for the first time
    persysUser.files = [".cache/noctalia/shell-state.json"];

    homeManager = {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      programs.noctalia-shell.enable = true;
    };
  };
}
