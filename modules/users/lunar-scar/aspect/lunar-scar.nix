{
  den,
  __findFile,
  ...
}: let
  u = "lunar-scar";
  h = "/home/${u}";
in {
  den.aspects.lunar-scar = {
    includes = [
      (den.batteries.user-shell "fish")

      # Include all direct subaspects
      den.aspects.lunar-scar._
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
