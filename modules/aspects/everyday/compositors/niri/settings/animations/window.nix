{
  niri.animations.window.homeManager.programs.niri.settings.animations = {
    enable = true;
    window-open = {
      kind.easing = {
        curve = "cubic-bezier";
        curve-args = [
          0.22
          1.0
          0.36
          1.0
        ];
        duration-ms = 260;
      };

      custom-shader = ''
        vec4 open_color(vec3 coords_geo, vec3 size_geo) {
            float p = niri_clamped_progress;

            float slide_px = (1.0 - p) * 60.0;
            float slide_geo = slide_px / max(size_geo.x, 1.0);

            float scale = 0.985 + 0.015 * p;

            vec2 uv = coords_geo.xy;
            uv -= vec2(0.5, 0.5);
            uv /= scale;
            uv += vec2(0.5, 0.5);

            uv.y -= slide_geo;

            vec3 coords_tex = niri_geo_to_tex * vec3(uv, 1.0);
            vec4 color = texture2D(niri_tex, coords_tex.st);

            color *= p;
            return color;
        }
      '';
    };

    window-close = {
      kind.easing = {
        curve = "cubic-bezier";
        curve-args = [
          0.32
          0.0
          0.67
          0.0
        ];
        duration-ms = 180;
      };

      custom-shader = ''
        vec4 close_color(vec3 coords_geo, vec3 size_geo) {
            float p = niri_clamped_progress;
            float inv = 1.0 - p;

            float slide_px = p * 40.0;
            float slide_geo = slide_px / max(size_geo.x, 1.0);

            float scale = 1.0 - 0.012 * p;

            vec2 uv = coords_geo.xy;
            uv -= vec2(0.5, 0.5);
            uv /= scale;
            uv += vec2(0.5, 0.5);

            uv.y -= slide_geo;

            vec3 coords_tex = niri_geo_to_tex * vec3(uv, 1.0);
            vec4 color = texture2D(niri_tex, coords_tex.st);

            color *= inv;
            return color;
        }
      '';
    };

    window-resize = {
      kind.spring = {
        damping-ratio = 1.0;
        stiffness = 720;
        epsilon = 0.0001;
      };

      custom-shader = ''
        vec4 resize_color(vec3 coords_curr_geo, vec3 size_curr_geo) {
            vec3 coords_tex_next = niri_geo_to_tex_next * coords_curr_geo;
            vec4 color = texture2D(niri_tex_next, coords_tex_next.st);

            vec2 uv = coords_curr_geo.xy;
            float edge =
                min(min(uv.x, 1.0 - uv.x), min(uv.y, 1.0 - uv.y));

            float vignette = smoothstep(0.0, 0.06, edge);
            color.rgb *= mix(0.985, 1.0, vignette);

            return color;
        }
      '';
    };
  };
}
