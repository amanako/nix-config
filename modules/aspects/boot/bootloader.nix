{
  den.aspects.bootloader.provides.limine = {
    stylix.targets."limine".enable = false;

    nixos = {pkgs, ...}: {
      boot.loader = {
        efi.canTouchEfiVariables = true;
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
            wallpaperStyle = "stretched";
            wallpapers = [
              (pkgs.fetchurl {
                url = "https://pic1.cdncl.net/game/user_upload/hssaole/36d351cc7ab10fadfb1953704de2b5d4.jpeg";
                hash = "sha256-si07feEPfDcxfTUGrL7ThVRtp8pHxwtrff+DLOXqZpM=";
              })
            ];
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
        timeout = 5;
      };
    };
  };
}
