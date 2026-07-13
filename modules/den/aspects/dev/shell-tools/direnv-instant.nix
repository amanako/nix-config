{
  den,
  inputs,
  ...
}: {
  flake-file.inputs.direnv-instant.url = "github:Mic92/direnv-instant";

  den.aspects.dev.shell-tools.direnv-instant = {
    description = ''
      Non-blocking direnv integration daemon that provides
      instant shell prompts by running direnv asynchronously in the background.
    '';

    includes = [
      den.aspects.dev.shell-tools.direnv
    ];

    hm = {user, ...}: {
      imports = [
        inputs.direnv-instant.homeModules.direnv-instant
      ];

      programs.direnv-instant = {
        enable = true;
        enableFishIntegration = true;
        enableKittyIntegration =
          den.aspects.dev.terminal.kitty
          |> user.hasAspect;
      };
    };
  };
}
