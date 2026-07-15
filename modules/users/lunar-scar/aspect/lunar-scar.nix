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
      den.aspects.basic.git

      den.aspects.everyday.utility._
      den.aspects.everyday.wallpaper-managers.awww

      den.aspects.dev.terminal.zellij
      den.aspects.dev.terminal.kitty
      den.aspects.dev.terminal.yazi
      den.aspects.dev.terminal.llm-agents
      den.aspects.dev.editors.helix
      den.aspects.dev.shells.fish
      den.aspects.dev.shell-tools._

      den.aspects.security.ssh
      den.aspects.security.gpg
      den.aspects.security.sops

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
      initialPassword = "koko";
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
