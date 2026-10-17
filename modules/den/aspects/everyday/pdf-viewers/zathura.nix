{
  den.aspects.everyday.pdf-viewers.zathura = {
    description = "A minimal, plugin-based document viewer supporting PDF, DjVu, and more.";

    persistUser.directories = [
      # Remember where user left of
      ".local/share/zathura"
    ];

    hm = {user, ...}: {
      programs.zathura = {
        enable = true;
        options = {
          recolor = true;
          recolor-adjust-lightness = false;
          recolor-keephue = true;
          recolor-reverse-video = false;

          # Don't limit previous results to display
          show-recent = -1;
          show-hidden = true;
          show-directories = true;

          render-loading = false;
          font = user.preferences.monofont.name;
          # c - command line # s - "statusbar"
          guioptions = "cs";
          zoom-step = 25;

          statusbar-basename = false;
          statusbar-home-tilde = true;
          statusbar-page-percent = true;

          vertical-center = true;

          window-icon-document = true;
          window-title-basename = true;
          window-title-tilde = false;
          window-title-page = false;

          dbus-service = false;
          synctext = false;

          highlighter-modifier = "ctrl";
          page-cache-size = 30;
          scroll-step = 60;

          selection-clipboard = "clipboard";
        };
      };
    };
  };
}
