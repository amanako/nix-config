{
  inputs,
  den,
  lib,
  ...
}: let
  persys = {host, ...}: {aspect-chain, ...}:
    den._.forward {
      each = lib.singleton true;
      fromClass = _item: "persys";
      intoClass = _item: "nixos";
      intoPath = _item: [
        "environment"
        "persistence"
        host.impermanence.persistenceDir
      ];
      fromAspect = _item: lib.head aspect-chain;
      adaptArgs = {config, ...}: {
        osConfig = config;
      };
      guard = {options, ...}: options ? environment.persistence;
    };

  persysUser = {
    host,
    user,
    ...
  }: {aspect-chain, ...}:
    den._.forward {
      each = lib.singleton true;
      fromClass = _item: "persysUser";
      intoClass = _item: "nixos";
      intoPath = _item: [
        "environment"
        "persistence"
        host.impermanence.persistenceDir
        "users"
        user.userName
      ];
      fromAspect = _item: lib.head aspect-chain;
      adaptArgs = {config, ...}: {
        osConfig = config;
      };
      guard = {options, ...}: options ? environment.persistence;
    };

  stylix = {aspect-chain, ...}:
    den._.forward {
      each = [
        "nixos"
        "homeManager"
      ];
      fromClass = _item: "stylix";
      intoClass = lib.id; # Use the item directly as the target class
      intoPath = _item: ["stylix"];
      fromAspect = _item: lib.head aspect-chain;
      adaptArgs = {config, ...}: {
        osConfig = config;
      };
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
    includes = [persys];
    nixos = {
      imports = [inputs.impermanence.nixosModules.impermanence];
      # This should be minimal for a truly pure setup
      fileSystems."${host.impermanence.persistenceDir}".neededForBoot = true;
    };
  };

  den.aspects.filesystem = {host, ...}: {
    includes =
      lib.optionals (host.disko.devices != {}) [den.aspects.disko]
      ++ lib.optionals (host.impermanence.enable) [den.aspects.impermanence];
  };

  den.aspects.stylix = {host, ...}:
    lib.optionalAttrs host.enableStyling {
      includes = [
        stylix
      ];
      nixos = {
        pkgs,
        config,
        ...
      }: {
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
              name = "Victor Mono Nerd Font";
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

  den.aspects.timezone = {host, ...}: {
    nixos.time.timeZone = host.timeZone or "UTC";
  };

  den.aspects.base-host = den.lib.parametric {
    includes = [
      den._.hostname
      den.aspects.filesystem
      den.aspects.timezone
    ];
  };

  den.ctx.host.includes = [
    den.aspects.base-host
    den.aspects.overlays
    den.aspects.stylix
  ];

  den.ctx.user.includes = [
    den._.define-user
    den._.mutual-provider
    # Currently this does nothing if host doesn't import impermanence
    persysUser
  ];
}
