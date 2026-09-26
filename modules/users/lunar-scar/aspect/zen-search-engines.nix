{
  den.aspects.lunar-scar.personal-zen-search-engines = {
    description = ''
      Collection of lunar scar's additional custom search engines for usage in zen browser.
    '';

    zenSearchEngines = {iconBasePath, ...}: let
      weblioIcon = "${iconBasePath}/apps/com.github.ryonakano.louper.svg";
      kotobankIcon = "${iconBasePath}/apps/meow.svg";
    in {
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
    };
  };
}
