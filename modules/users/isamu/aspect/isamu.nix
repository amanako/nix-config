{
  den,
  niri,
  zen-browser,
  nixvim,
  ...
}: {
  den.aspects.isamu = {
    includes = [
      niri.full
      zen-browser._
      zen-browser.search.nix
      zen-browser.search.wikis

      den.aspects.ui.launchers.vicinae
      den.aspects.ui.launchers.vicinae.extensions
      den.aspects.ui.notifications.dunst
      den.aspects.utilities.mpv
      den.aspects.utilities.localsend
      den.aspects.utilities.youtube-tui
      den.aspects.utilities.wifitui
      den.aspects.utilities.bluetui
      den.aspects.utilities.btop
      den.aspects.ui.wallpaper-managers.awww
      den.aspects.utilities.pdf-viewers.pdf-cli

      den.aspects.core.nix.nh
      den.aspects.core.flatpaks.sober

      den.aspects.extra.nix-utils.nix-index-database
      den.aspects.extra.bleeding-edge.chaotic
      den.aspects.extra.gaming.lutris
      den.aspects.extra.gaming.steam
      den.aspects.extra.gaming.optimizations

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
      nixvim.plugins.snacks-dashboard
      nixvim.plugins.snacks-explorer

      nixvim.plugins.kitty-scrollback
      nixvim.plugins.lualine
      nixvim.plugins.rainbow-delimiters
      nixvim.plugins.which-key

      nixvim.plugins.blink-cmp
      nixvim.plugins.lsp-lines
      nixvim.plugins.lsp
      nixvim.plugins.noice
      nixvim.plugins.trouble
      nixvim.plugins.lsp
      nixvim.plugins.toggleterm

      nixvim.plugins.oravim
      nixvim.plugins.treesitter

      den.aspects.dev.shells.fish
      den.aspects.dev.tools.fastfetch
      den.aspects.dev.tools.bat
      den.aspects.dev.tools.eza
      den.aspects.dev.tools.fzf
      den.aspects.dev.tools.git
      den.aspects.dev.tools.zoxide
      den.aspects.dev.tools.starship
      den.aspects.dev.tools.direnv-instant

      den.aspects.dev.terminal.kitty
      den.aspects.dev.terminal.yazi
      den.aspects.dev.terminal.yazi.plugins._
      den.aspects.dev.terminal.opencode

      den.aspects.security.ssh
      den.aspects.security.gpg

      den.aspects.ui.bars.waybar
    ];
  };
}
