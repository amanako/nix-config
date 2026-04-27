{
  den.aspects.hardware = {
    nixos = {pkgs, ...}: {
      services.pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
      };

      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {
          General = {
            Experimental = true;
            Testing = true;
            KernelExperimental = true;
          };
        };
      };

      networking.networkmanager.enable = true;

      boot.loader.efi.canTouchEfiVariables = true;
      boot.loader.limine = {
        enable = true;
        package = pkgs.limine-full;

        style = {
          interface.helpHidden = true;
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
          backdrop = "008080";
        };

        # Limine may fill up quickly
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
}
