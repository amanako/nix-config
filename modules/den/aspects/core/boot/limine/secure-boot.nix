{lib, ...}: {
  den.aspects.core.boot.limine.secure-boot = {
    persistSystem.directories = [
      "/var/lib/sbctl"
    ];

    nixos = {pkgs, ...}: {
      # Status can be verified via sbctl status, sbctl verify.
      environment.systemPackages = with pkgs; [
        sbctl
      ];

      boot.loader.limine = {
        # Editor must be disabled for security reasons (upstream requirement).
        enableEditor = lib.mkForce false;
        secureBoot.enable = true;
      };
    };
  };
}
