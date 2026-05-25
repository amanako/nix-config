{
  __findFile,
  lib,
  ...
}: {
  den.aspects.bootloader.provides.limine = {
    secureBoot = {host, ...}:
      lib.optionalAttrs host.wantsSecureBootSupport {
        provides.to-hosts.persys.directories = [
          "/var/lib/sbctl"
        ];

        nixos = {pkgs, ...}: {
          # Status can be verified via sbctl status, sbctl verify.
          environment.systemPackages = with pkgs; [
            sbctl
          ];

          boot.loader.limine = {
            # Editor must be disabled for security reasons.
            enableEditor = lib.mkForce false;

            # While admitedly it is possible to use autoGenerateKeys and autoEnrollKey options,
            # I only faced trouble and following guide from README should be a one-time setup anyway.
            secureBoot.enable = true;
          };
        };
      };

    includes = [
      <bootloader/limine/secureBoot>
    ];

    stylix.targets."limine".enable = false;

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
            wallpapers = map ({
              url,
              hash,
            }:
              pkgs.fetchurl {
                inherit url hash;
              })
            host.limine.wallpapers;
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
