{
  zen-browser.bookmarks = {user, ...}: {
    homeManager = {config, ...}: {
      programs.zen-browser.profiles."${user.userName}".bookmarks = {
        # These settings should be in sync
        force = config.programs.zen-browser.policies.NoDefaultBookmarks;
        settings = [];
      };
    };
  };
}
