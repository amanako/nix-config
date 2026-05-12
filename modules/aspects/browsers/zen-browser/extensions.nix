{
  zen-browser.extensions = {user, ...}: {
    homeManager = {
      inputs',
      lib,
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
          "uBlock0@raymondhill.net".settings = {
            userSettings = {
              uiTheme = "dark";
              cloudStorageEnabled = lib.mkForce false;
            };
            selectedFilterLists = [
              "ublock-filters"
              "ublock-badware"
              "ublock-privacy"
              "ublock-quick-fixes"
              "plowe-0"
              "easyprivacy"
              "fanboy-cookiemonster"
              "ublock-cookies-easylist"
              "fanboy-social"
              "ublock-annoyances"
            ];
          };

          "addon@darkreader.org".settings = {
            syncSettings = true;
          };
        };
      };
    };
  };
}
