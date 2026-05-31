{
  zen-browser.extensions.homeManager = {
    user,
    inputs',
    ...
  }: {
    programs.zen-browser.profiles."${user.userName}".extensions = {
      force = true;

      packages = with inputs'.firefox-addons.packages; [
        darkreader
        proton-pass
        vimium-c
        ublock-origin
        addy_io
      ];

      settings = {
        #Reference: https://github.com/gorhill/uBlock/wiki/Deploying-uBlock-Origin:-configuration
        "uBlock0@raymondhill.net".settings = {
          userSettings = {
            uiTheme = "dark";
            advancedUserEnabled = true;
            autoUpdate = false;
            prefetchingDisabled = false;
            webrtcIPAddressHidden = true;
          };

          selectedFilterLists = [
            "user-filters"
            "ublock-filters"
            "ublock-badlists"
            "ublock-cookies-adguard"
            "ublock-badware"
            "ublock-privacy"
            "ublock-quick-fixes"
            "plowe-0"
            "adguard-cookies"
            "adguard-social"
            "easylist"
            "easyprivacy"
            "fanboy-cookiemonster"
            "ublock-cookies-easylist"
            "fanboy-social"
            "ublock-annoyances"
            "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/hosts/pro.txt"
          ];
        };

        "addon@darkreader.org".settings = {
          syncSettings = true;
        };
      };
    };
  };
}
