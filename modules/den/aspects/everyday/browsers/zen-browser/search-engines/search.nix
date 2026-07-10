{zen-browser, ...}: {
  zen-browser.search = {
    includes = [
      zen-browser.searchEnginesCollector
    ];

    zenUserSettings.search = {
      force = true;
      default = "ddg";
      privateDefault = "ddg";
    };
  };
}
