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
      den.aspects.everyday.notifications.dunst
      den.aspects.everyday.utility.mpv

      den.aspects.everyday.wallpaper-managers.awww

      den.aspects.core.flatpaks.sober

      nixvim.entry
      nixvim.plugins.telescope
      nixvim.plugins.treesitter
      nixvim.plugins.lsp
      nixvim.plugins.lazygit
      nixvim.plugins.gitsigns
      nixvim.plugins.lint
      nixvim.plugins.conform

      den.aspects.dev.shell-tools.fastfetch
      den.aspects.dev.shell-tools.bat
      den.aspects.dev.shell-tools.eza
      den.aspects.dev.shell-tools.fzf
      den.aspects.dev.shell-tools.git
      den.aspects.dev.shell-tools.starship

      den.aspects.dev.shells.fish

      den.aspects.dev.terminal.kitty
      den.aspects.dev.terminal.yazi
      den.aspects.dev.terminal.yazi.plugins._

      den.aspects.security.ssh
      den.aspects.security.gpg

      den.aspects.extra.bleeding-edge.chaotic
      den.aspects.extra.gaming.lutris
      den.aspects.extra.gaming.steam
      den.aspects.extra.gaming.optimizations

      den.aspects.extra.stylix

      den.aspects.everyday.bars.waybar
    ];
  };
}
