# reference: about:config in zen
{
  zen-browser.settings.homeManager = {
    user,
    lib,
    ...
  }: {
    programs.zen-browser.profiles."${user.userName}".settings = let
      urlbarDontSuggest = [
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
        lib.foldl' (
          acc: name: acc // {"browser.urlbar.suggest.${name}" = false;}
        ) {}
        urlbarDontSuggest;
    in
      urlbarDontSuggestPreferences
      // {
        "browser.warnonclose" = false;
        "browser.warnonquit" = false;
        "browser.url.quicksuggest.enabled" = false;
        "browser.url.quicksuggest.online.enabled" = false;
        "font.cjk_pref_fallback_order" = "ja,zh-cn,zh-hk,zh-tw,ko";
        # Pretty
        "font.default.ja" = "serif";
        "services.sync.engine.addons" = false;
        "services.sync.engine.addresses" = false;
        "services.sync.engine.credicards" = false;
        "services.sync.engine.passwords" = false;
        "services.sync.engine.bookmarks" = true;
        "services.sync.engine.history" = true;
        "services.sync.engine.prefs" = true;
        "services.sync.engine.tabs" = true;
        "services.sync.engine.workspaces" = true;
        "extensions.autoDisableScopes" = 0;
        "zen.window-sync.enabled" = false;
      };
  };
}
