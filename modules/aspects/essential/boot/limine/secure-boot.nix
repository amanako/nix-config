{lib, ...}: {
  den.aspects.boot.loader.limine.secureBoot = {host}: {
    description = ''
      Secure boot functionality for limine. Automatically enabled when host opts in
      for via wantsSecureBootSupport option. Should not be include directly.
    '';

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
}
