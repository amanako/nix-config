{
  den.aspects.utility.zathura = {
    stylixHMSettings.targets."zathura".enable = false;

    homeManager.programs.zathura = {
      enable = true;
      options = {
        recolor = true;
        recolor-adjust-lightness = true;
        recolor-lightcolor = "#1e3a8a";
        recolor-darkcolor = "#e0f2fe";
        recolor-keephue = true;
        recolor-reverse-video = true;

        # Don't limit previous results to display
        show-recent = -1;
        show-hidden = true;
        show-directories = true;

        render-loading = false;
        font = "VictorMono NF";
        # c - command line
        guioptions = "c";
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

        highlight-color = "#32302f";
        highlight-active-color = "#d3868b";
        highlighter-modifier = "ctrl";
        page-cache-size = 30;
        scroll-step = 60;

        selection-clipboard = "clipboard";
      };
    };
  };
}
