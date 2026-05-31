{
  den,
  __findFile,
  ...
}: let
  u = "lunar-scar";
in {
  den.aspects.lunar-scar = {
    includes = [
      (den.batteries.user-shell "fish")

      den.aspects.security._
      den.aspects.utility._
      den.aspects.shell._

      <browsers/zen-browser-full>
      <compositors/niri-full>
      <shells/noctalia-full>

      <terminal/zellij>
      <terminal/kitty>
      <terminal/yazi>

      <editors/nixvim>

      <nix/nh>
      <nixUtils/nixIndexDatabase>

      <gaming/optimizations>
      <gaming/software>
      <default-shell>
    ];

    user = {
      initialPassword = "koko";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIPG5huz0B9qZ1gcuvMhCrc63piDJML/Hc/STMl55GWg awaremi"
      ];
    };

    persysUser.directories = [
      "Dev"
      "Documents"
      "Downloads"
      "Faks"
      "nix-config" # Main config
      "Pictures"
      {
        directory = "keys/ssh";
        mode = "0700";
      }
      {
        directory = "keys/gnupg";
        mode = "0700";
      }

      # For direnv to remember allowed .envrc files
      ".local/share/youtube-tui"
      ".local/share/systemd/timers"
    ];

    nixos = {pkgs, ...}: {
      fonts.packages = with pkgs; [
        mona-sans

        noto-fonts-cjk-serif
        ipafont
        biz-ud-gothic
        inconsolata
        nerd-fonts.victor-mono
      ];
    };

    homeManager = {
      user,
      pkgs,
      config,
      ...
    }: {
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
      ];

      # Add a custom fontconfig file from current directory
      fonts.fontconfig.enable = true;
      home.file.".config/fontconfig/fonts.conf".source = config.lib.file.mkOutOfStoreSymlink "${user.repoRoot}/assets/users/${u}/fontconfig.conf";

      # Add personal config file for fcitx5
      # Recusrive is necessary when it's a folder
      home.file.".config/fcitx5" = {
        source = config.lib.file.mkOutOfStoreSymlink "${user.repoRoot}/assets/users/${u}/fcitx5";
        recursive = true;
      };

      # Tell niri to start with these programs
      programs.niri.settings.spawn-at-startup = [
        {
          command = ["fcitx5"];
        }
      ];

      programs.gpg.homedir = "${config.home.homeDirectory}/keys/gnupg";

      programs.ssh.settings."*" = {
        host = "codeberg.org";
        hostname = "codeberg.org";
        user = "git";
        port = 22;
        identityFile = "~/keys/ssh/id_ed25519";
        userKnownHostsFile = "~/keys/ssh/known_hosts";
        hashKnownHosts = true;
      };
    };
  };
}
