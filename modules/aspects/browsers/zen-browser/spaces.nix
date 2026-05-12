{
  zen-browser.spaces = {user, ...}: {
    homeManager = {
      programs.zen-browser.profiles."${user.userName}" = {
        spacesForce = true;
        spaces = {
          "Personal" = {
            id = "10000000-0000-4000-8000-000000000001";
            icon = "☕";
            position = 1000;
            container = 1;
          };

          "College" = {
            id = "10000000-0000-4000-8000-000000000002";
            icon = "📚";
            position = 2000;
            container = 2;
          };

          "JP" = {
            id = "10000000-0000-4000-8000-000000000003";
            icon = "🈳";
            position = 3000;
            container = 3;
          };
        };
      };
    };
  };
}
