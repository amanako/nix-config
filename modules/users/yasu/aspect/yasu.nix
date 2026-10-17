{
  den,
  # Bring namespace aspects into scope when __findFile lookup won't suffice
  nixvim,
  zen-browser,
  niri,
  ...
}: let
  kintoruUser =
    den.hosts.aarch64-linux.kintoru.users
    |> builtins.attrNames
    |> builtins.head;

  kintoruRemotes = {
    kintoru-eth = "192.168.100.80";
    kintoru-wifi = "192.168.100.81";
    kintoru-usb = "10.0.0.2";
  };
in {
  den.aspects.yasu = {
    includes = [
      # Include all direct subaspects created under my user
      den.aspects.yasu._

      den.aspects.everyday.utility.anki
      den.aspects.everyday.utility.localsend
      den.aspects.everyday.utility.fcitx5
      den.aspects.everyday.utility.mpv
      den.aspects.everyday.utility.youtube-tui
      den.aspects.everyday.utility.wifitui
      den.aspects.everyday.utility.bluetui
      den.aspects.everyday.utility.btop
      den.aspects.everyday.pdf-viewers.pdf-cli

      den.aspects.everyday.wallpaper-managers.awww

      den.aspects.dev.terminal.zellij
      den.aspects.dev.terminal.kitty

      den.aspects.dev.terminal.yazi
      den.aspects.dev.terminal.yazi.plugins.chmod
      den.aspects.dev.terminal.yazi.plugins.full-border
      den.aspects.dev.terminal.yazi.plugins.piper
      den.aspects.dev.terminal.yazi.plugins.smart-enter
      den.aspects.dev.terminal.yazi.plugins.starship
      den.aspects.dev.terminal.yazi.plugins.zoom
      den.aspects.dev.terminal.opencode

      den.aspects.dev.editors.helix
      den.aspects.dev.shells.nushell
      den.aspects.dev.shells.fish
      den.aspects.dev.shell-tools._
      den.aspects.dev.shell-tools.starship
      den.aspects.dev.shell-tools.jujutsu
      den.aspects.dev.shell-tools.git

      den.aspects.everyday.launchers.vicinae
      den.aspects.everyday.launchers.vicinae.extensions
      den.aspects.everyday.bars.waybar
      den.aspects.everyday.notifications.dunst

      den.aspects.security.ssh
      den.aspects.security.gpg
      den.aspects.security.sops-user

      den.aspects.core.nix.nh
      den.aspects.core.flatpaks.sober

      den.aspects.extra.nix-utils.nix-index-database
      den.aspects.extra.gaming.optimizations
      den.aspects.extra.gaming.steam
      den.aspects.extra.gaming.lutris
      den.aspects.extra.gaming.unstable-packages

      # Works for namespaces as well
      zen-browser.full
      niri.full

      nixvim.entry
      nixvim.opts
      nixvim.keymaps
      nixvim.extras
      nixvim.extra-config
      nixvim.dependencies

      nixvim.plugins.bufferline
      nixvim.plugins.yazi
      nixvim.plugins.telescope

      nixvim.plugins.conform
      nixvim.plugins.lint

      nixvim.plugins.gitsigns
      nixvim.plugins.lazygit
      nixvim.plugins.mini

      nixvim.plugins.kitty-scrollback
      nixvim.plugins.lualine
      nixvim.plugins.rainbow-delimiters
      nixvim.plugins.which-key

      nixvim.plugins.blink-cmp
      nixvim.plugins.lsp-lines
      nixvim.plugins.lsp
      nixvim.plugins.noice
      nixvim.plugins.trouble

      nixvim.plugins.treesitter
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

    hm = {
      pkgs,
      lib,
      ...
    }: {
      home.packages = with pkgs; [
        nemo
        abiword
        which
        file
        ripgrep
      ];

      programs.gpg.homedir = "/home/yasu/keys/gnupg";

      programs.ssh.settings =
        {
          "*" = {
            host = "codeberg.org";
            hostname = "codeberg.org";
            user = "git";
            port = 22;
            identityFile = "~/keys/ssh/id_ed25519";
            userKnownHostsFile = "~/keys/ssh/known_hosts";
            hashKnownHosts = true;
          };
        }
        // (kintoruRemotes
          |> lib.mapAttrs' (
            name: hostname:
              lib.nameValuePair name {
                inherit hostname;
                user = kintoruUser;
              }
          ));
    };
  };
}
