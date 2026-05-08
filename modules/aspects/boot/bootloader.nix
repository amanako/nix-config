{
  den.aspects.bootloader = {
    provides.limine = {
      stylix = {
        targets = {
          "limine".enable = false;
        };
      };

      nixos = {pkgs, ...}: {
        boot.loader.limine = {
          enable = true;
          resolution = "1920x1080x32";
          style = {
            interface = {
              resolution = "1920x1080";
              branding = "Paranoia";
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
          extraEntries = "/memtest86
                              protocol: chainload
                              path: boot():///efi/memtest86/memtest86.efi";
        };

        # Setting to 0 will hide the OS choice for bootloaders.
        # Any keypress will trigger it, but with limine causes a flash.
        # I have decided to keep it at non-0, other bootloaders should be OK.
        boot.loader.timeout = 5;
      };
    };
  };
}
