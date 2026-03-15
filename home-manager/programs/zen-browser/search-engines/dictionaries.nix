{ iconBasePath, ...}:

let
  merrianWebsterIcon = "${iconBasePath}/apps/org.gnome.Dictionary.svg";
  weblioIcon = "${iconBasePath}/apps/com.github.ryonakano.louper.svg";
  kotobankIcon = "${iconBasePath}/apps/meow.svg";
in
{
  merriam-webster = {
    name = "Merriam-Webster Dictionary";
    template = "https://www.merriam-webster.com/dictionary/{searchTerms}";
    icon = merrianWebsterIcon;
    aliases = ["@mw"];
  };

  weblio-jp = {
    name = "Weblio辞書";
    template = "https://www.weblio.jp/content/{searchTerms}";
    icon = weblioIcon;
    aliases = ["@wj"];
  };

  kotobank = {
    name = "コトバンク";
    template = "https://kotobank.jp/search?q={searchTerms}&t=ja";
    icon = kotobankIcon;
    aliases = ["@kb"];
  };
}
