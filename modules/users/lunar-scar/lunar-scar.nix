{ den, ... }:

let
  u = "lunar-scar";
  h = "/home/${u}";
in
{
  den.aspects.${u} = {
    includes = [
      (den._.unfree [
        "nvidia-x11"
        "nvidia-settings"
        "steam"
        "steam-unwrapped"
        "rar"
        "unrar"
      ])
      den._.primary-user
      (den._.user-shell "fish")
    ]
    ++ (with den.aspects; [
      appearance
      terminal
      dev
      nix
      shell
      system
      system._.noctalia
      editors._.nixvim
      editors._.helix
      gaming
      browsers._.zen-browser
      utility
    ]);

    user = {
      isNormalUser = true;
      initialPassword = "koko";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN3FV9ENyYeC2/oiTYklKYSW3zEeUIDiv4kY6SLpVvGD github@kairi6.anonaddy.com"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIt+pO+vGitCLBgAza007py6ze41xHFfMDSLfbd2K/ES codeberg"
      ];
    };

    nixos =
      { pkgs, ... }:
      {
        # All locales follow this format:
        # {country-code}.{encoding-standard}/{encoding-standard}
        i18n.extraLocales = [ "ja_JP.UTF-8/UTF-8" ];

        fonts.packages = with pkgs; [
          mona-sans

          noto-fonts-cjk-serif
          ipafont
          biz-ud-gothic
          inconsolata
          nerd-fonts.victor-mono
        ];

        users.mutableUsers = false;

        # TODO: Use options to achieve conditionals
        stylix.targetsToDisable = [
          "fish"
          "limine"
        ];
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
          p7zip
          unzip
          unrar

          # Must have
          nixfmt

          # Development
          cmake
          gnumake

          capitaine-cursors
          bibata-cursors
          wineWow64Packages.stable
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

        # TODO: Usage of custom option
        stylix.targetsToDisable = [
          "kitty"
          "yazi"
          "fcitx5"
          "starship"
          "nixvim"
          "neovim"
          "zen-browser"
          "noctalia-shell"
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

        programs.niri.autoSpawnShell = "noctalia";

        # Example config for dms
        # programs.dank-material-shell = {
        #  userSettings = {
        #    fontFamily = "Mona Sans Display Light";
        #    monoFontFamily = "Victor Mono Nerd Font";
        #    notepadFontFamily = "Noto Serif CJK JP";
        #    powerMenuActions = [
        #      "restart"
        #      "logout"
        #      "lock"
        #      "suspend"
        #      "poweroff"
        #      "reboot"
        #    ];

        # Ensure you have installed the package first
        #    iconTheme = "papirus";
        #    networkPreference = "ethernet";

        #    currentThemeName = "custom";
        #    currentThemeCategory = "registry";
        #    registryThemeVariants = {
        #       gruvboxMaterial = "medium";
        #   };
        #    cursorSettings.size = 36;
        #    cursorSettings.theme = "capitaine-cursors-white";
        #  };

        #   userSession = rec {
        #    nightModeAutoEnabled = true;
        #    nightModeAutoMode = "location";

        #    latitude = 43.3333;
        #    longitude = 21.9097;
        #    weatherLocation = "Serbia, Niš";
        #    weatherCoordinates = "${toString latitude},${toString longitude}";
        #  };
        #};

        programs.noctalia-shell.userSettings = {
          location = "Serbia, Niš";
        };

        programs.git.settings.user = {
          name = "amanako";
          email = "github@kairi6.anonaddy.com";
        };

        programs.git.signing = {
          key = "0606F86026761462";
          signByDefault = true;
        };

        programs.gpg = {
          enable = true;
        };

        services.gpg-agent = {
          enable = true;
          pinentry.package = pkgs.pinentry-curses;
          enableFishIntegration = true;
          enableSshSupport = true;
        };

        programs.ssh = {
          enableDefaultConfig = false;
          matchBlocks."*" = {
            host = "github.com";
            user = "git";
            port = 22;
            identityFile = "~/.ssh/id_ed25519_ama";
          };
        };
      };
  };
}
