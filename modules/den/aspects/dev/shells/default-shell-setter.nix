{...}: {
  # I am aware that den.batteries.user-shell exists but it isn't complete with shell support.
  # Therefore this aspect is supposed to represent universal solution to the shell problem.

  den.aspects.dev.shells.default-shell-setter = {
    description = ''
      Aspect to wire in default shell for the user, based on user.settings.dev.shells.defaultShell option.
    '';

    user = {
      user,
      pkgs,
      ...
    }: {
      shell = pkgs.${user.settings.dev.shells.defaultShell};
    };

    # Home manager already handles enabling the shell so just enable shell on hosts so that users will be able to use them.
    nixos = {
      user,
      lib,
      ...
    }: {
      programs =
        user.settings.dev.shells.activeShells
        |> lib.flip lib.genAttrs (_: {enable = true;});
    };
  };
}
