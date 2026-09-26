{
  zen-browser.containers.example = {
    description = ''
      Example aspect demonstrating usage of zen containers.
      Using zenProfileSettings quirk automatically assembles and
      builds all of them. Since they are commonly used with spaces,
      it is recommended to take a look at `zen-browser.spaces.example` aspect too.
      Requirements: Include `zen-browser.entry` aspect.
    '';

    zenProfileSettings = {
      containersForce = true;

      containers = {
        "Personal" = {
          id = 1;
          color = "turquoise";
          icon = "fence";
        };

        "Work" = {
          id = 2;
          color = "purple";
          icon = "briefcase";
        };
      };
    };
  };
}
