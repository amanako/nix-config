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
        imports = with inputs.self.modules.nixos; [
          stylix
          localsend
          steam
          openssh
          fonts
          fontconfig
          extraLocales-jp
        ];

        programs.fish.enable = true;
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

        home.sessionVariables = {
          EDITOR = "nvim";
          TERM = "kitty";
          BROWSER = "zen-browser";
          FILE_MANAGER = "yazi";
          NH_FLAKE = "${h}/nix-config/";
        };

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
