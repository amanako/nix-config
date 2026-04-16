{ iconBasePath, ... }:

let
  nixPkgsIcon = "${iconBasePath}/mimetypes/application-x-alpm-package.svg";
  noogleDevIcon = "${iconBasePath}/apps/activity-log-manager.svg";
in
{
  nix-pkgs = {
    name = "Nix Packages";
    template = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
    icon = nixPkgsIcon;
    aliases = [ "@np" ];
  };

  # Uses default icon
  mynixos = {
    name = "My NixOS";
    template = "https://mynixos.com/search?q={searchTerms}";
    aliases = [ "@nx" ];
  };

  # Nix function reference
  "noogle.dev" = {
    name = "Noogle";
    template = "https://noogle.dev/q?term={searchTerms}";
    icon = noogleDevIcon;
    aliases = [ "@ng" ];
  };
}
