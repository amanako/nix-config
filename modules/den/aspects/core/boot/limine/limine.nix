{
  den,
  lib,
  ...
}: {
  den.aspects.core.boot.limine = {
    description = ''
      From [description](https://github.com/Limine-Bootloader/Limine):
      Modern, secure, portable, multiprotocol bootloader and boot manager.
    '';

    includes = [
      den.aspects.core.boot.limine.secure-boot
    ];

    stylixNixOSSettings.targets."limine".enable = false;

    hostSettings = let
      inherit
        (lib)
        mkOption
        types
        ;
    in {
      wallpapers = mkOption {
        type = types.listOf (types.submoduleWith {
          modules = [
            {
              options.url = mkOption {
                type = lib.types.str;
                default = "";
                description = "Remote url to be used to fetch wallpapers.";
              };

              options.hash = mkOption {
                type = types.str;
                default = "";
                description = ''
                  Hash used to compute corresponding wallpaper url.
                  Can be obtained by trying to rebuild system once and looking at the error.
                  The hash can be looked up from column 'got' in this way:
                  error: hash mismatch in fixed-output derivation '...':
                    likely URL: ...
                    specified: ...
                    got: <this is the hash>
                    expected path: ...
                    got path: ...
                '';
              };
            }
          ];
        });

        default = [];
        example = [
          {
            url = "https://w.wallhaven.cc/full/2e/2ewm1x.jpg";
            hash = "sha256-000000000000000000000000000000000000000000000=";
          }
        ];
        description = ''
          List of remote links of wallpapers to use for limine, Will be fetched and passed to
          `boot.loader.limine.style.wallpapers`. If multiple specified, randomized on boot.
        '';
      };
    };

    nixos = {
      host,
      pkgs,
      ...
    }: {
      boot.loader = {
        efi.canTouchEfiVariables = true;
        timeout = 5;
        limine = {
          enable = true;
          package = pkgs.limine-full;
          resolution = "1920x1080x32";
          style = {
            backdrop = "008080";
            interface = {
              helpHidden = true;
              resolution = "1920x1080";
              branding = "Paranoia";
            };
            graphicalTerminal = {
              # Format for background: TTRRGGBB where TT is transparency (not opacity!)
              # Range: 00 - FF (hex)
              # background = "20665c54";
              foreground = "928374";

              font.scale = "8x16";
              font.spacing = 3;
              margin = 20;
              marginGradient = 10;
            };
            wallpapers =
              host.settings.core.boot.limine.wallpapers
              |> map ({
                url,
                hash,
              }:
                pkgs.fetchurl {
                  inherit
                    url
                    hash
                    ;
                });
          };
          panicOnChecksumMismatch = true;
          # Boot partition may fill up quickly
          maxGenerations = 10;
          efiSupport = true;
          enableEditor = true;
          extraConfig = ''
            serial: yes
            verbose: yes
          '';
        };
      };
    };
  };
}
