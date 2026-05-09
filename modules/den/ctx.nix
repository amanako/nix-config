{
  inputs,
  den,
  lib,
  ...
}: let
  persistClass = isUser: {
    host,
    user,
    ...
  }: {aspect-chain, ...}:
    den._.forward {
      each = ["host" "user"];
      fromClass = target: "persys${lib.optionalString (target == "user") "User"}";
      intoClass = _item: "nixos";
      intoPath = target:
        [
          "environment"
          "persistence"
          host.impermanence.persistenceDir
        ]
        ++ lib.optionals (target == "user") [
          "users"
          user.userName
        ];
      fromAspect = _item: lib.head aspect-chain;
      adaptArgs = {config, ...}: {
        osConfig = config;
      };
      guard = {options, ...}: options ? environment.persistence;
    };

  stylixClass = {aspect-chain, ...}:
    den._.forward {
      each = ["nixos" "homeManager"];
      fromClass = target: "stylix${lib.optionalString (target == "homeManager") "Home"}";
      intoClass = lib.id;
      intoPath = _: ["stylix"];
      fromAspect = _: lib.head aspect-chain;
      adaptArgs = {config, ...}: {osConfig = config;};
      guard = {options, ...}: options ? stylix;
    };
in {
  flake-file.inputs = {
    disko.url = "github:nix-community/disko";
    impermanence.url = "github:nix-community/impermanence";
    stylix.url = "github:nix-community/stylix";
  };

  den.aspects.disko = {host, ...}: {
    nixos = {
      imports = [inputs.disko.nixosModules.disko];
      inherit (host) disko;
    };
  };

  den.aspects.impermanence = {host, ...}: {
    includes = [persistClass];
    nixos = {
      imports = [inputs.impermanence.nixosModules.impermanence];
      # This should be minimal for a truly pure setup
      fileSystems."${host.impermanence.persistenceDir}".neededForBoot = true;
    };
  };

  den.aspects.filesystem = {host, ...}: {
    includes =
      lib.optional (host.disko.devices != {}) den.aspects.disko
      ++ lib.optional host.impermanence.enable den.aspects.impermanence;
  };

  den.aspects.stylix = {host, ...}:
    lib.optionalAttrs host.enableStyling {
      nixos = {
        pkgs,
        config,
        ...
      }: {
        # Automatically enables stylix for home manager if detected
        imports = [inputs.stylix.nixosModules.stylix];
        stylix = {
          enable = true;
          base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-soft.yaml";
          polarity = "dark";
          opacity = {
            applications = 0.87;
            desktop = 0.85;
            popups = 0.86;
            terminal = 0.85;
          };

          icons = {
            enable = true;
            package = pkgs.papirus-icon-theme;
            dark = "Papirus-Dark";
            light = "Papirus-Light";
          };

          fonts = {
            monospace = {
              package = pkgs.nerd-fonts.victor-mono;
              name = "VictorMono Nerd Font";
            };
            sansSerif = {
              package = pkgs.inter;
              name = "Inter";
            };
            # Serif fonts can be bothersome
            serif = config.stylix.fonts.sansSerif;
            emoji = {
              package = pkgs.twemoji-color-font;
              name = "Twemoji";
            };
          };
        };
      };
    };

  den.aspects.style = {host, ...}: {
    includes = lib.optional host.enableStyling den.aspects.stylix;
  };

  den.aspects.timezone = {host, ...}: {
    nixos.time.timeZone = host.timeZone or "UTC";
  };

  den.aspects.base-host = den.lib.parametric {
    includes = [
      den._.hostname
      den.aspects.filesystem
      den.aspects.timezone
      den.aspects.style
    ];
  };

  den.ctx.host.includes = [
    den.aspects.base-host
    den.aspects.overlays
  ];

  den.ctx.user.includes = [
    den._.define-user
    den._.mutual-provider
    # Currently this does nothing if host doesn't import impermanence
    stylixClass
  ];
}
