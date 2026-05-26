{
  niri.animations.other.homeManager.programs.niri.settings.animations = {
    workspace-switch = {
      kind.spring = {
        damping-ratio = 1.0;
        stiffness = 760;
        epsilon = 0.0001;
      };
    };

    horizontal-view-movement = {
      kind.spring = {
        damping-ratio = 1.0;
        stiffness = 640;
        epsilon = 0.0001;
      };
    };

    window-movement = {
      kind.spring = {
        damping-ratio = 1.0;
        stiffness = 700;
        epsilon = 0.0001;
      };
    };

    config-notification-open-close = {
      kind.spring = {
        damping-ratio = 1.0;
        stiffness = 820;
        epsilon = 0.001;
      };
    };

    exit-confirmation-open-close = {
      kind.spring = {
        damping-ratio = 1.0;
        stiffness = 560;
        epsilon = 0.01;
      };
    };

    screenshot-ui-open = {
      kind.easing = {
        curve = "cubic-bezier";
        curve-args = [
          0.22
          1.0
          0.36
          1.0
        ];
        duration-ms = 220;
      };
    };

    overview-open-close = {
      kind.spring = {
        damping-ratio = 1.0;
        stiffness = 620;
        epsilon = 0.0001;
      };
    };
  };
}
