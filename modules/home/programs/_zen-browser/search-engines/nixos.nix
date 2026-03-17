{ iconBasePath, ... }:

let
  nixPkgsIcon = "${iconBasePath}/mimetypes/application-x-alpm-package.svg";
in
{
  nix-pkgs = {
    name = "Nix Packages";
    template = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
    icon = nixPkgsIcon;
    aliases = [ "@np" ];
  };

  # uses default icon
  mynixos = {
    name = "My NixOS";
    template = "https://mynixos.com/search?q={searchTerms}";
    aliases = [ "@nx" ];
  };
}
