{ iconBasePath, ... }:

let
  nixosWikiIcon = "${iconBasePath}/apps/stock_help.svg";
  nixosWikiUnofficialIcon = "${iconBasePath}/apps/org.zim_wiki.Zim.svg";
  archIcon = "${iconBasePath}/apps/distributor-logo-archlinux.svg";
in
{
  nixos-wiki = {
    name = "Official NixOS Wiki";
    template = "https://wiki.nixos.org/w/index.php?search={searchTerms}&title=Special%3ASearch&wprov=acrw1_-1";
    icon = nixosWikiIcon;
    aliases = ["@nw"];
  };

  nixos-wiki-unofficial = {
    name = "Unofficial NixOS Wiki";
    template = "https://nixos.wiki/index.php?search={searchTerms}&go=Go";
    icon = nixosWikiUnofficialIcon;
    aliases = ["@nwun"];
  };

  arch-wiki = {
    name = "Arch Wiki";
    template = "https://wiki.archlinux.org/index.php?search={searchTerms}&title=Special%3ASearch";
    icon = archIcon;
    aliases = ["@aw"];
  };
}
