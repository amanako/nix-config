{
  den,
  nixvim,
  zen-browser,
  niri,
  noctalia,
  __findFile,
  ...
}: let
  u = "lunar-scar";
  h = "/home/${u}";
in {
  flake.den = den;
  den.aspects.lunar-scar = {
    # Temporary workaround for namespaced aspects not importing all direct children children
    includes = with nixvim.plugins;
      [
        yazi
        treesitter
        trouble
        telescope
        conform
        lsp
        blink-cmp
        lint
        competitest
        kitty-scrollback
        lazygit
        lualine
        luasnip
        lsplines
        undotree
        bufferline
        noice
        rainbow-delimiters
        which-key
      ]
      ++ [
        (den.batteries.user-shell "fish")

        # Include all direct subaspects created under my user and other ones
        den.aspects.lunar-scar._
        den.aspects.security._
        den.aspects.utility._
        den.aspects.shell._

        # Works for namespaces as well
        zen-browser._
        noctalia._
        noctalia.plugins._
        niri._
        niri.animations.window
        niri.animations.other

        nixvim._
        # Additionaly import all plugins

        <terminal/zellij>
        <terminal/kitty>
        <terminal/yazi>

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
