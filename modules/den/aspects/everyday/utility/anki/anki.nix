{den, ...}: {
  den.aspects.everyday.utility.anki = {
    description = ''
      Anki is a flashcard program that helps you spend more time on challenging material, and less on what you already know.
    '';

    persistUser.directories = [
      # Backups, addons and profiles
      ".local/share/Anki2"
    ];

    hm = {
      user,
      lib,
      config,
      pkgs,
      ...
    }: {
      programs.anki = {
        enable = true;
        addons = with pkgs; [
          # Useful integration
          ankiAddons.anki-connect
        ];

        profiles."${user.userName}" = {
          default = true;

          sync = let
            wantsSync =
              user.hasAspect den.aspects.security.sops
              && builtins.hasAttr "anki-key" config.sops.secrets;
          in
            lib.optionalAttrs wantsSync {
              autoSync = true;
              syncMedia = true;
              keyFile = config.sops.secrets.anki-key.path;
            };
        };

        hideTopBar = true;
        hideTopBarMode = "fullscreen";
        hideBottomBar = true;
        hideBottomBarMode = "fullscreen";

        minimalistMode = true;
        style = "native";
        theme = "followSystem";
        videoDriver = "opengl";
      };
    };
  };
}
