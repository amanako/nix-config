{den, ...}: let
  u = "lunar-scar";
  h = "/home/${u}";
in {
  den.aspects.${u} = {
    includes =
      [
        den._.primary-user
        (den._.user-shell "fish")
      ]
      ++ (with den.aspects; [
        appearance
        terminal
        dev
        nix
        shell

        compositors._.niri
        niri-binds
        shells._.noctalia
        shells._.noctalia._.niri
        editors._.nixvim
        # TODO: Look for failing to initiate init.lua out of $XDG_HOME
        # editors._.neovim
        editors._.helix
        gaming
        browsers._.zen-browser
        utility
      ]);

    user = {
      initialPassword = "koko";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIt+pO+vGitCLBgAza007py6ze41xHFfMDSLfbd2K/ES codeberg"
      ];
    };

    persysUser = {
      directories = [
        "Dev"
        "Documents"
        "Downloads"
        "Faks"
        "nix-config" # Main config
        "Pictures"

        ".local/share/youtube-tui"
      ];
    };

    nixos = {pkgs, ...}: {
      fonts.packages = with pkgs; [
        mona-sans

        noto-fonts-cjk-serif
        ipafont
        biz-ud-gothic
        inconsolata
        nerd-fonts.victor-mono
      ];

      stylix.targetsToDisable = [
        "fish"
        "limine"
      ];
    };

    homeManager = {pkgs, ...}: {
      home.packages = with pkgs; [
        thunar
        youtube-tui
        abiword

        # Nice command line tools
        which
        file
        pciutils
        usbutils
        ripgrep

        # Must have
        nixfmt

        # Development
        cmake
        gnumake

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
        BROWSER = "zen-twilight";
        FILE_MANAGER = "yazi";

        # NH_FLAKE variable for rebuilding with nh without specyfing flake location
        NH_FLAKE = "${h}/nix-config/";
      };

      # Tell niri to start with these programs
      programs.niri.settings.spawn-at-startup = [
        {
          command = ["fcitx5"];
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
        location.name = "Serbia, Niš";
      };

      programs.git.settings.user = {
        name = "abyssal-twilight";
        email = "codeberg@kairi6.anonaddy.com";
      };

      programs.git.signing = {
        key = "8AE5B72E5D17E0F5";
      };

      programs.ssh = {
        enableDefaultConfig = false;
        matchBlocks."*" = {
          host = "codeberg.org";
          user = "git";
          port = 22;
          identityFile = "~/.ssh/id_ed25519";
        };
      };
    };
  };
}
