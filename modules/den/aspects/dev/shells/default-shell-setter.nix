{den, ...}: {
  # I am aware that den.batteries.user-shell exists but it isn't complete with shell support.
  # Therefore this aspect is supposed to represent universal solution to the shell problem.

  den.aspects.dev.shells.default-shell-setter = {
    description = ''
      Aspect to wire in default shell for the user, based on user.settings.dev.shells.defaultShell option.
      For this aspect to take effect user needs to enable at least one shell to work with.
    '';

    user = {
      user,
      pkgs,
      lib,
      ...
    }: let
      defaultShell = user.settings.dev.shells.defaultShell or null;
    in
      lib.optionalAttrs (defaultShell != null) {
        shell = pkgs.${defaultShell};
      };

    # Home manager already handles enabling the shell so just enable shell on hosts so that users will be able to use them.
    nixos = {
      user,
      lib,
      ...
    }: let
      unsupportedNixOSShells = ["nushell"];
      supportedShells =
        den.aspects.dev.shells
        |> lib.filterAttrs (n: v: (v |> builtins.isAttrs) && !(n |> lib.hasPrefix "_"))
        |> builtins.attrNames
        |> lib.remove "default-shell-setter"
        |> lib.filter (shell: den.aspects.dev.shells.${shell} |> user.hasAspect)
        # Remove shells not supported by nixos.programs options
        |> lib.filter (shell: !(unsupportedNixOSShells |> lib.elem shell));
    in {
      programs =
        supportedShells
        |> lib.flip lib.genAttrs (_: {enable = true;});
    };
  };
}
