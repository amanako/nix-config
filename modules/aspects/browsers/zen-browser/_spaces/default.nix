{ config, ... }:

let
  containers = config.programs.zen-browser.profiles."*".containers;
in
{
  "Personal" = {
    id = "c6de089c-410d-4206-961d-ab11f988d40a";
    icon = "🧩";
    container = containers."Personal".id;
    position = 1000;
  };

  "College" = {
    id = "cdd10fab-4fc5-494b-9041-325e5759195b";
    icon = "👜";
    container = containers."College".id;
    position = 2000;
  };

  "JP" = {
    id = "78aabdad-8aae-4fe0-8ff0-2a0c6c4ccc24";
    icon = "🈳";
    container = containers."JP".id;
    position = 3000;
  };
}
