{
  # Less important settings lie here
  niri.other = {
    homeManager = {pkgs, ...}: {
      home.packages = [
        pkgs.capitaine-cursors-themed
      ];
    };

    niriSettings = {
      overview.workspace-shadow.enable = false;

      # csd = client side decoration
      # When true, windows will be rectangular and omit csd
      prefer-no-csd = false;

      # Don't show keys at startup
      hotkey-overlay.skip-at-startup = true;

      cursor = {
        hide-after-inactive-ms = 3000;
        hide-when-typing = true;
        size = 42;
        theme = "Capitaine Cursors (Gruvbox) - White";
      };
    };
  };
}
