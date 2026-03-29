{ den, ... }:

let
  u = "lunar-scar";
  h = "/home/lunar-scar";
in
{
  den.aspects.${u} = {
    includes = [
      den._.define-user
      den._.primary-user
      (den._.user-shell "fish")
    ]
    ++ [
      den.aspects.appearance
      den.aspects.terminal
      den.aspects.dev
      den.aspects.shell
      den.aspects.nix
      # den.aspects.system
      den.aspects.system._.dms
      den.aspects.terminal._.nixvim
      den.aspects.gaming
      den.aspects.browsers._.zen-browser
      den.aspects.utility
    ];

    user = {
      isNormalUser = true;
      initialPassword = "koko";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJu+Btx2UdY+nVSsHXs9BfSIJfeZuUgFSDHqAFvWD8rN codeberg@kairi6.anonaddy.com"
      ];
    };

    nixos =
      { pkgs, ... }:
      {
        # All locales follow this format:
        # {country-code}.{encoding-standard}/{encoding-standard}
        i18n.extraLocales = [ "ja_JP.UTF-8/UTF-8" ];

        fonts.packages = with pkgs; [
          # Crucial
          nerd-fonts.victor-mono
          mona-sans

          noto-fonts-cjk-serif
          ipafont
          biz-ud-gothic
          inconsolata
        ];

        users.mutableUsers = false;
      };

    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          protonup-qt
          lutris
          thunar
          youtube-tui
          abiword

          # Nice command line tools
          which
          file
          pciutils
          usbutils
          ripgrep
          fastfetch
          p7zip
          unzip
          unrar
          bat

          # Must have
          nixfmt

          # Development
          clang
          cmake
          gnumake

          wineWow64Packages.stable

          capitaine-cursors
          bibata-cursors
        ];

        # Add a custom fontconfig file from current directory
        fonts.fontconfig.enable = true;
        home.file.".config/fontconfig/fonts.conf".source = ./fontconfig.conf;

        # Add personal config file for fcitx5
        # Recusrive is necessary when it's a folder
        home.file.".config/fcitx5" = {
          source = ./fcitx5;
          recursive = true;
        };

        # Use options to achieve conditionals
        stylix.targetsToDisable = [
          # Temporary
          "qt"
          "kitty"
          "yazi"
          "fcitx5"
          "starship"
          "nixvim"
          "dank-material-shell"
        ];

        home.sessionVariables = {
          # This 4 variables should be configured because other components might use them
          EDITOR = "nvim";
          TERM = "kitty";
          BROWSER = "zen-beta";
          FILE_MANAGER = "yazi";

          # NH_FLAKE variable for rebuilding with nh without specyfing flake location
          NH_FLAKE = "${h}/nix-config/";
        };

        # Tell niri to start with these programs
        programs.niri.settings.spawn-at-startup = [
          {
            command = [ "fcitx5" ];
          }
        ];

        programs.niri.autoSpawnShell = "dms";

        programs.dank-material-shell = {
          userSettings = {
            fontFamily = "Mona Sans Display Light";
            monoFontFamily = "Victor Mono Nerd Font";
            notepadFontFamily = "Noto Serif CJK JP";
            powerMenuActions = [
              "restart"
              "logout"
              "lock"
              "suspend"
              "poweroff"
              "reboot"
            ];

            iconTheme = "papirus";
            networkPreference = "ethernet";

            currentThemeName = "custom";
            currentThemeCategory = "registry";
            customThemeFile = "/home/lunar-scar/.config/DankMaterialShell/themes/gruvboxMaterial/theme.json";
            registryThemeVariants = {
              gruvboxMaterial = "medium";
            };
          };

          userSession = rec {
            nightModeAutoEnabled = true;
            nightModeAutoMode = "location";

            latitude = 43.3333;
            longitude = 21.9097;
            weatherLocation = "Serbia, Niš";
            weatherCoordinates = "${toString latitude},${toString longitude}";
          };
        };

        programs.git.settings.user = {
          name = "abyssal-twilight";
          email = "codeberg@kairi6.anonaddy.com";
        };

        programs.ssh = {
          enableDefaultConfig = false;
          matchBlocks."*" = {
            host = "codeberg.org";
            user = "git";
            port = 22;
            identityFile = "~/.ssh/id_ed25519_codeberg";
          };
        };
      };
  };
}
