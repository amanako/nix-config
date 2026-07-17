{zen-browser, ...}: {
  zen-browser.search = {
    includes = [
      zen-browser.searchEnginesCollector
    ];

    zenProfileSettings.search = {
      force = true;
      default = "ddg";
      privateDefault = "ddg";
    };
  };
}
