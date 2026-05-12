{
  zen-browser.containers = {user, ...}: {
    homeManager.programs.zen-browser.profiles."${user.userName}" = {
      containersForce = true;
      containers = {
        "Personal" = {
          id = 1;
          color = "purple";
          icon = "fingerprint";
        };

        "College" = {
          id = 2;
          color = "orange";
          icon = "briefcase";
        };

        "JP" = {
          id = 3;
          color = "green";
          icon = "gift";
        };
      };
    };
  };
}
