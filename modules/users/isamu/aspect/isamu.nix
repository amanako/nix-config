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

      den.aspects.everyday.launchers.vicinae
      den.aspects.everyday.launchers.vicinae.extensions
      den.aspects.everyday.notifications.dunst
      den.aspects.everyday.utility.mpv
      den.aspects.everyday.utility.localsend
      den.aspects.everyday.wallpaper-managers.awww

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
      nixvim.colorschemes.gruvbox
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
      nixvim.plugins.lsp

      nixvim.plugins.treesitter

      den.aspects.dev.shells.fish
      den.aspects.dev.shell-tools.fastfetch
      den.aspects.dev.shell-tools.bat
      den.aspects.dev.shell-tools.eza
      den.aspects.dev.shell-tools.fzf
      den.aspects.dev.shell-tools.git
      den.aspects.dev.shell-tools.starship
      den.aspects.dev.shell-tools.direnv-instant

      den.aspects.dev.terminal.kitty
      den.aspects.dev.terminal.yazi
      den.aspects.dev.terminal.yazi.plugins._

      den.aspects.security.ssh
      den.aspects.security.gpg

      den.aspects.extra.stylix

      den.aspects.everyday.bars.waybar
    ];
  };
}
