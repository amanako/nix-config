{
  zen-browser.bookmarks.homeManager = {user, ...}: {
    programs.zen-browser.profiles."${user.userName}".bookmarks = {
      force = true;
    };
  };
}
