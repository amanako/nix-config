{lib, ...}: {
  den.aspects.dev.terminal.zellij = {
    description = "A terminal workspace and multiplexer with batteries included.";

    userSettings = {user, ...}: let
      inherit
        (lib)
        mkOption
        types
        ;
    in {
      autoAttach = mkOption {
        default = false;
        example = true;
        type = types.bool;
        description = "Whether zellij should attach when starting shell sessions";
      };

      autoExit = let
        cfg = user.settings.dev.terminal.zellij;
      in
        mkOption {
          default = false;
          example = true;
          type = types.bool;
          description = ''
            Whether zellij should exit when exiting nushell session.
            This option is read only when user.settings.dev.terminal.zellij.autoAttach is set to false.
          '';
          readOnly = !cfg.autoAttach;
        };
    };

    stylixHMSettings.targets."zellij".enable = true;
    # Zellij uses cache folders to revive sessions on reboot or crashes
    persistUser.directories = [
      ".cache/zellij"
    ];

    hm = {user, ...}: {
      programs.zellij = let
        cfg = user.settings.dev.terminal.zellij;
      in {
        enable = true;
        attachExistingSession = cfg.autoAttach;
        exitShellOnExit = cfg.autoExit;
      };
    };
  };
}
