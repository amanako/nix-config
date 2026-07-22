{
  den,
  # Bring namespace aspects into scope when __findFile lookup won't suffice
  nixvim,
  zen-browser,
  niri,
  noctalia,
  ...
}: let
  u = "lunar-scar";
  h = "/home/${u}";
in {
  den.aspects.lunar-scar = {
    includes = [
      # Include all direct subaspects created under my user and other ones
      den.aspects.lunar-scar._

      # `everyday.utility` is a folder of sibling top-level aspects, not a
      # parent aspect with sub-keys, so `._` resolves to nothing here and will
      # not surface any of them. Each utility aspect must be included by its
      # full attrpath for its userSettings/hm to activate (this is the intended
      # opt-in mechanism — settings are pruned to included aspects).
      # TODO: add something so that utility._ includes anki settings
      den.aspects.everyday.utility.anki
      den.aspects.everyday.utility.localsend
      den.aspects.everyday.utility.fcitx5
      den.aspects.everyday.utility.mpv
      den.aspects.everyday.utility.youtube-tui
      den.aspects.everyday.utility.zathura

      den.aspects.everyday.wallpaper-managers.awww

      den.aspects.dev.terminal.zellij
      den.aspects.dev.terminal.kitty
      den.aspects.dev.terminal.yazi
      den.aspects.dev.terminal.vix
      den.aspects.dev.editors.helix
      den.aspects.dev.shells.nushell
      den.aspects.dev.shells.fish
      den.aspects.dev.shell-tools._
      den.aspects.dev.shell-tools.jujutsu
      den.aspects.dev.shell-tools.git

      den.aspects.security.ssh
      den.aspects.security.gpg
      den.aspects.security.sops-user

      den.aspects.core.nix.nh

      den.aspects.extra.nix-utils.nix-index-database
      den.aspects.extra.gaming.optimizations
      den.aspects.extra.gaming.software
      den.aspects.extra.bleeding-edge.chaotic

      # Works for namespaces as well
      zen-browser.full
      noctalia.full
      niri.full

      # Pending fix
      nixvim._
      nixvim.plugins._
    ];

    user = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIPG5huz0B9qZ1gcuvMhCrc63piDJML/Hc/STMl55GWg awaremi"
      ];
    };

    persistUser.directories = [
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
    ];

    hm = {pkgs, ...}: {
      home.packages = with pkgs; [
        nemo
        youtube-tui
        abiword

        # Nice command line tools
        which
        file
        pciutils
        usbutils
        ripgrep
      ];

      programs.gpg.homedir = "${h}/keys/gnupg";

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
