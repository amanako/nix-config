{
  __findFile,
  den,
  inputs,
  ...
}: {
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

  den.aspects.shells.noctalia-full.includes = [
    <shells/noctalia>
    <noctalia/plugins/official>

    <noctalia/settings>
    <noctalia/settings/bar>
    <noctalia/settings/appLauncher>
    <noctalia/settings/calendar>
    <noctalia/settings/controlCenter>
    <noctalia/settings/general>
    <noctalia/settings/idle>
    <noctalia/settings/location>
    <noctalia/settings/nightLight>
    <noctalia/settings/notifications>
    <noctalia/settings/sessionMenu>
    <noctalia/settings/systemMonitor>
    <noctalia/settings/ui>
  ];

  den.aspects.shells.noctalia = {
    stylixHome.targets."noctalia-shell".enable = false;

    # TODO: Look into reason why this only works for the first time
    persysUser.files = [".cache/noctalia/shell-state.json"];

    includes = [
      (
        den.lib.policy.when
        ({user, ...}: user.hasAspect <shells/noctalia> && user.hasAspect <compositors/niri>)
        (den.lib.policy.include <noctalia/niri>)
      )
    ];

    homeManager = {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      programs.noctalia-shell.enable = true;
    };
  };
}
