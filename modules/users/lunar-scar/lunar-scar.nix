{ inputs, den, ... }:
let
  u = "lunar-scar";
  h = "/home/lunar-scar";
in
{
  den.aspects.lunar-scar = {
    includes = [
      den.provides.define-user
    ];

    user = {
      isNormalUser = true;
      initialPassword = "koko";
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
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

        imports = with inputs.self.modules.nixos; [
          stylix
          localsend
          steam
          openssh
        ];

        fonts.packages = with pkgs; [
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-color-emoji
          liberation_ttf
          dina-font
          proggyfonts
          nerd-fonts.victor-mono
          biz-ud-gothic
          maple-mono.CN
          maple-mono.NF
          mona-sans
          ipafont
        ];

        users.users.${u}.shell = pkgs.fish;
        users.mutableUsers = false;
      };

    homeManager =
      { pkgs, ... }:
      {
        imports = with inputs.self.hmModules; [
          niri
          noctalia

          zen-browser
          nixvim
          fcitx5
          git
          nix-index-database
          eza
          fish
          fzf
          nh
          ssh
          zoxide
          kitty
          starship
          yazi
          mpv
        ];

        home.packages = with pkgs; [
          protonup-qt
          lutris
          thunar
          kdePackages.okular
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

        home.sessionVariables = {
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
            command = [ "noctalia-shell" ];
          }
          {
            command = [ "fcitx5" ];
          }
          {
            command = [ "zen-beta" ];
          }
        ];

        programs.git.settings.user = {
          name = "arcane-moonlight";
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
