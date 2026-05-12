{
  zen-browser.bookmarks = {user, ...}: {
    homeManager.programs.zen-browser.profiles."${user.userName}".bookmarks = {
      force = true;
    };
  };
}
