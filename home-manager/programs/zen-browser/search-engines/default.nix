{ pkgs, ... }:

{
  nix-pkgs = {
    name = "Nix Packages";
    urls = [
      {
        template = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={searchTerms}";
        params = [
          {
            name = "query";
            value = "searchTerms";
          }
        ];
      }
    ];
    icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    definedAliases = ["@np"];
  };

  mynixos = {
    name = "My NixOS";
    urls = [
      {
        template = "https://mynixos.com/search?q={searchTerms}";
        params = [
          {
            name = "query";
            value = "searchTerms";
          }
        ];
      }
    ];
    icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    definedAliases = ["@nx"];
	};

  nixos-wiki = {
    name = "Official NixOS Wiki";
    urls = [
      {
        template = "https://wiki.nixos.org/w/index.php?search={searchTerms}&title=
          Special%3ASearch&wprov=acrw1_-1";
        params = [
          {
            name = "query";
            value = "searchTerms";
          }
        ];
      }
    ];
    icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    definedAliases = ["@nw"];
  };

  nixos-wiki-unofficial = {
    name = "Unofficial NixOS Wiki";
    urls = [
      {
        template = "https://nixos.wiki/index.php?search={searchTerms}&go=Go";
        params = [
          {
            name = "query";
            value = "searchTerms";
          }
        ];
      }
    ];
    icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    definedAliases = ["@nwun"];
  };

  arch-wiki = {
    name = "Arch Wiki";
    urls = [
      {
        template = "https://wiki.archlinux.org/index.php?search={searchTerms}&title=Special%3ASearch}";
        params = [
          {
            name = "query";
            value = "searchTerms";
          }
        ];
      }
    ];
    # TODO: Fix icon
    icon = "${pkgs.papirus-icon-theme}/Papirus/48x48/apps/distributor-logo-archlinux.svg";
    definedAliases = ["@aw"];
  };
}
