{
  zen-browser.search.dictionaries = {
    zenSearchEngines = {iconBasePath, ...}: let
      merrianWebsterIcon = "${iconBasePath}/apps/org.gnome.Dictionary.svg";
    in {
      merriam-webster = {
        name = "Merriam-Webster Dictionary";
        template = "https://www.merriam-webster.com/dictionary/{searchTerms}";
        icon = merrianWebsterIcon;
        aliases = ["@mw"];
      };
    };
  };
}
