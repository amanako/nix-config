{
  niri.animations.smoothened = {
    description = ''
      Smoothened window resize animation.
    '';

    niriSettings.animations = {
      window-resize = {
        kind.spring = {
          damping-ratio = 1.0;
          stiffness = 650;
          epsilon = 0.0001;
        };

        # Based on niri's official crossfade example:
        # https://github.com/niri-wm/niri/blob/main/docs/wiki/examples/resize_custom_shader.frag
        custom-shader.text = ''
          vec4 resize_color(vec3 coords_curr_geo, vec3 size_curr_geo) {
              // Map the animating geometry into the previous window geometry
              // and clamp it to the old bounds. Growing past the old window
              // then keeps its content scaled smoothly instead of sampling
              // past the old surface or snapping to the reflowed layout.
              vec3 coords_prev_geo =
                  niri_curr_geo_to_prev_geo * coords_curr_geo;
              vec2 uv_prev = clamp(coords_prev_geo.st, 0.0, 1.0);
              vec3 coords_tex_prev =
                  niri_geo_to_tex_prev * vec3(uv_prev, 1.0);
              vec4 color_prev = texture2D(niri_tex_prev, coords_tex_prev.st);

              // Map the animating geometry into the reflowed texture.
              vec3 coords_tex_next = niri_geo_to_tex_next * coords_curr_geo;
              vec4 color_next = texture2D(niri_tex_next, coords_tex_next.st);

              // Hold the old, smoothly-scaled content for most of the
              // animation and blend into the reflowed content near the end.
              // This runs in both directions, so expanding a window is the
              // exact reverse of folding it down.
              float t = smoothstep(0.35, 1.0, niri_clamped_progress);
              vec4 color = mix(color_prev, color_next, t);

              // Soften the edges while the surface is being scaled.
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
  };
}
