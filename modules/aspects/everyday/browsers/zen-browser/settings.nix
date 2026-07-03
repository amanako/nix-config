{
  zen-browser.settings = {
    # reference: about:config in zen
    # some of my findings for clean fuss-free experience

    zenUserSettings = {lib, ...}: {
      settings = let
        urlbarDontSuggestList = [
          "addons"
          "amp"
          "calculator"
          "clipboard"
          "history"
          "mdn"
          "openpage"
          "pocket"
          "quickactions"
          "realtimeoptin"
          "recentsearches"
          "searches"
          "sports"
          "trending"
          "weather"
        ];

        urlbarDontSuggestPreferences =
          urlbarDontSuggestList
          |> lib.foldl' (
            acc: name: acc // {"browser.urlbar.suggest.${name}" = false;}
          ) {};
      in
        urlbarDontSuggestPreferences
        // {
          "browser.warnonclose" = false;
          "browser.warnonquit" = false;
          "browser.url.quicksuggest.enabled" = false;
          "browser.url.quicksuggest.online.enabled" = false;
          "services.sync.engine.addons" = false;
          "services.sync.engine.addresses" = false;
          "services.sync.engine.credicards" = false;
          "services.sync.engine.passwords" = false;
          "services.sync.engine.bookmarks" = true;
          "services.sync.engine.history" = true;
          "services.sync.engine.prefs" = true;
          "services.sync.engine.tabs" = true;
          "services.sync.engine.workspaces" = true;
          # Automatically enable newly installed extensions
          "extensions.autoDisableScopes" = 0;

          "zen.window-sync.enabled" = false;

          # Force workspace containers
          "zen.workspaces.force-container-workspace" = true;
        };
    };
  };
}
