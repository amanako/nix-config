{
  den.aspects.lunar-scar.zen-settings = {
    description = ''
      "Additional zen browser settings for lunar-scar."
    '';

    zenProfileSettings = {
      settings = {
        "font.cjk_pref_fallback_order" = "ja,zh-cn,zh-hk,zh-tw,ko";
        "font.default.ja" = "serif";
      };

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

        "Dev" = {
          id = 4;
          color = "pink";
          icon = "cart";
        };

        "Other" = {
          id = 5;
          color = "turquoise";
          icon = "fingerprint";
        };
      };

      spacesForce = true;
      spaces = {
        "Personal" = {
          id = "10000000-0000-4000-8000-000000000001";
          icon = "☕";
          position = 1;
          container = 1;
        };

        "College" = {
          id = "10000000-0000-4000-8000-000000000002";
          icon = "🎓";
          position = 2;
          container = 2;
        };

        "JP" = {
          id = "10000000-0000-4000-8000-000000000003";
          icon = "🈳";
          position = 3;
          container = 3;
        };

        "Dev" = {
          id = "10000000-0000-4000-8000-000000000004";
          icon = "🖥️";
          position = 4;
          container = 4;
        };

        "Other" = {
          id = "10000000-0000-4000-8000-000000000005";
          icon = "✨";
          position = 5;
          container = 5;
        };
      };
    };
  };
}
