{
  den,
  lib,
  ...
}: {
  den.aspects.everyday.utility.anki = {
    description = ''
      Anki is a flashcard program that helps you spend more time on challenging material, and less on what you already know.
    '';

    # Supposing that one user doesn't want multiple profiles.
    # Also recommended by upstream: https://docs.ankiweb.net/profiles.html#profiles.
    userSettings = {user, ...}: {
      profileName = lib.mkOption {
        type = lib.types.str;
        default = user.userName;
        example = "flashcardMaster";
        description = "Name to use for the Anki profile";
      };
    };

    persistUser.directories = [
      # Backups, addons and profiles
      ".local/share/Anki2"
    ];

    # Multiple breakages, fragile package.
    userPackageChannels.anki = "stable";

    hm = {
      user,
      lib,
      config,
      pkgs,
      ...
    }: let
      cfg = user.settings.everyday.utility.anki;
    in {
      programs.anki = {
        enable = true;
        package = pkgs.anki.overrideAttrs (old: {
          nativeBuildInputs = old.nativeBuildInputs ++ [pkgs.pkg-config];
          buildInputs = old.buildInputs ++ [pkgs.sqlite pkgs.zstd];
          env =
            (old.env or {})
            // {
              UV_FIND_LINKS = "${old.env.UV_FIND_LINKS},${pkgs.python3Packages.tomlkit.dist}";
            };
        });

        addons = with pkgs; [
          ankiAddons.anki-connect
        ];

        profiles."${cfg.profileName}" = {
          default = true;

          sync = let
            wantsSync =
              user.hasAspect den.aspects.security.sops-user
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
