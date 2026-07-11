{
  zen-browser.bookmarks = {
    persistUser = {user, ...}: {
      directories = [
        ".config/zen/${user.userName}/bookmarkbackups"
      ];
    };

    zenUserSettings.bookmarks = {
      settings = [];
    };
  };
}
