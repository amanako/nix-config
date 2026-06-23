{den, ...}: {
  den.aspects.core.boot.limine = {
    description = ''
      From [description](https://github.com/Limine-Bootloader/Limine):
      Modern, secure, portable, multiprotocol bootloader and boot manager.
    '';

    includes = [
      den.aspects.core.boot.limine.secureBoot
    ];

    stylixNixOSSettings.targets."limine".enable = false;

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
              host.limine.wallpapers
              |> map ({
                url,
                hash,
              }:
                pkgs.fetchurl {
                  inherit url hash;
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
