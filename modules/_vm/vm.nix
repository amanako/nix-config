# enables `nix run .#vm`. it is very useful to have a VM
# you can edit your config and launch the VM to test stuff
# instead of having to reboot each time.
{ inputs, den, ... }:

{
  den.aspects.nebula.includes = [ (den.provides.tty-autologin "lunar-scar") ];

  den.aspects.nebula.nixos =
    { pkgs, lib, ... }:
    {
      # Force disable NVIDIA in VM variant
      services.xserver.videoDrivers = lib.mkForce [ "virtio" ];
      boot.initrd.availableKernelModules = lib.mkForce [
        "xhci_pci"
        "virtio_pci"
        "virtio_blk"
        "virtio_net"
        "ext4"
        "dm_mod"
        "9p" # 9p filesystem
        "9pnet" # 9p network transport
        "9pnet_virtio" # 9p over virtio
        "overlay" # Nix overlay system
      ];
      boot.initrd.kernelModules = lib.mkForce [
        "dm_mod"
        "9p"
        "9pnet"
        "9pnet_virtio"
        "overlay"
      ];

      # Prevent colision of network devices
      networking.useNetworkd = lib.mkForce true;
      networking.useDHCP = lib.mkForce true;
      # Disable physical interface detection
      boot.kernelParams = [ "net.ifnames=0" ];

      # Use gnome instead of niri
      services.desktopManager.gnome.enable = true;

      # To disable installing GNOME's suite of applications
      # and only be left with GNOME shell.
      services.gnome.core-apps.enable = false;
      services.gnome.core-developer-tools.enable = false;
      services.gnome.games.enable = false;
      environment.gnome.excludePackages = with pkgs; [
        gnome-tour
        gnome-user-docs
      ];

      # Don't need battery in vm
      services.power-profiles-daemon.enable = lib.mkForce false;
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.vm = pkgs.writeShellApplication {
        name = "vm";
        text =
          let
            host = inputs.self.nixosConfigurations.nebula.config;
          in
          ''
            ${host.system.build.vm}/bin/run-${host.networking.hostName}-vm "$@"
          '';
      };
    };
}
