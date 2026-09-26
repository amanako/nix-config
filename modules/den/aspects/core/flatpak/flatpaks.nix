{inputs, ...}: {
  flake-file.inputs.flatpaks.url = "github:in-a-dil-emma/declarative-flatpak/latest";

  den.aspects.core.flatpaks = {
    description = ''
      Flatpak application sandboxing and distribution framework.
      Provides the declarative-flatpak home-manager module to users for per-user flatpak management.
    '';

    persistHost.directories = [
      "/var/lib/flatpak"
    ];

    persistUser.directories = [
      ".var/app"
      ".local/share/flatpak"
    ];

    hm = {pkgs, ...}: {
      imports = [
        inputs.flatpaks.homeModules.default
      ];

      home.packages = [
        pkgs.flatpak
      ];

      services.flatpak = {
        enable = true;
        remotes = {
          "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        };
      };
    };

    # Flatpak needs to be enabled on systems using home manager with nixos.
    # Causes the following:
    # Failed assertions:
    # user profile: You're using home-manager with NixOS.
    # Flatpak is not enabled in your NixOS config.
    # This setup is unsupported.
    nixos.services.flatpak.enable = true;
  };
}
