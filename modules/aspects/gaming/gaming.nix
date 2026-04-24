{ inputs, den, ... }:

{
  flake-file.inputs = {
    nix-gaming.url = "github:fufexan/nix-gaming";
  };

  den.aspects.gaming = {
    includes = [
      (den._.unfree [
        "steam"
        "steam-unwrapped"
      ])
    ];

    persysUser = {
      directories = [
        ".local/share/Steam"
        ".local/share/lutris/runners"
      ];
    };

    nixos =
      { pkgs, ... }:
      {
        imports = with inputs.nix-gaming.nixosModules; [
          platformOptimizations
          pipewireLowLatency
        ];

        services.pipewire.lowLatency.enable = true;
        # Make pipewire realtime-capable
        security.rtkit.enable = true;

        programs.gamemode = {
          enable = true;
          enableRenice = true;
        };

        programs.gamescope = {
          enable = true;
          capSysNice = true;
        };

        programs.steam = {
          enable = true;
          platformOptimizations.enable = true;

          remotePlay.openFirewall = true;
          dedicatedServer.openFirewall = true;
          gamescopeSession = {
            enable = true;
            env = {
              # Requires hardware.nvidia.prime.offload.enable
              __NV_PRIME_RENDER_OFFLOAD = "1";
              __VK_LAYER_NV_optimus = "NVIDIA_only";
              __GLX_VENDOR_LIBRARY_NAME = "nvidia";
            };
            args = [
              "-W"
              "1920"
              "-H"
              "1080"
              "-r"
              "144"
              # Fullscreen mode
              "-f"
              # Create 2 Xwayland instances (helps with certain games that need X11 support)
              "--xwayland-count"
              "2"
              "--hdr-enabled"
              "--hdr-debug-force-output"
              "--hdr-itm-enabled"
            ];
            steamArgs = [
              "pipewire-dmabuf"
              "-steamdeck"
              "-steamos3"
            ];
          };
          fontPackages = with pkgs; [
            biz-ud-gothic
            hanazono
          ];
          extraPackages = with pkgs; [
            gamescope
            gamescope-wsi
          ];

          extraCompatPackages = with pkgs; [
            proton-ge-bin
          ];
        };
      };

    homeManager = {
      programs.lutris = {
        enable = true;
      };
    };
  };
}
