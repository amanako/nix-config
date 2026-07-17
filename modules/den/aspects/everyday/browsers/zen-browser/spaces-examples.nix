{
  zen-browser.spaces.examples = {
    description = ''
      Example aspect demonstrating usage of zen containers.
      Using zenProfileSettings quirk automatically assembles and
      builds all of them. Since they are commonly used with containers,
      it is recommended to take a look at `zen-browser.containers.example` aspect too.
    '';

    zenProfileSettings = {
      spacesForce = true;

      spaces = {
        "Personal" = {
          id = "10000000-2000-3000-4000-000000000000";
          icon = "✨";
          position = 1000;
          # For each space to map to single unique container use unique container ids.
          # This creates all spaces matching containers which are then displayed side-by-side.
          container = 1;
        };

        "Work" = {
          id = "10000000-2000-3000-4000-000000000001";
          icon = "💼";
          position = 2000;
          container = 2;
        };
      };
    };
  };
}
