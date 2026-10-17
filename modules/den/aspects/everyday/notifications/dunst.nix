{
  den.aspects.everyday.notifications.dunst = {
    description = "Lightweight and customizable notification daemon.";

    hm.services.dunst = {
      enable = true;
      settings = {
        global = {
          width = 300;
          height = 300;
          offset = "30x50";
          origin = "top-right";
          transparency = 10;
        };

        urgency_normal = {
          timeout = 10;
        };
      };
    };
  };
}
