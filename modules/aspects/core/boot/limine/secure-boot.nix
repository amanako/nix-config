{lib, ...}: {
  den.aspects.core.boot.limine.secureBoot = {
    description = ''
      Secure boot functionality for limine. Automatically enabled when host opts in
      via wantsSecureBootSupport option.
    '';

    persistSystem.directories = [
      "/var/lib/sbctl"
    ];

    nixos = {
      host,
      pkgs,
      ...
    }:
      lib.optionalAttrs host.wantsSecureBootSupport {
        # Status can be verified via sbctl status, sbctl verify.
        environment.systemPackages = with pkgs; [
          sbctl
        ];

        boot.loader.limine = {
          # Editor must be disabled for security reasons.
          enableEditor = lib.mkForce false;

          # While admittedly it is possible to use autoGenerateKeys and autoEnrollKey options,
          # I only faced trouble and following guide from README should be a one-time setup anyway.
          secureBoot.enable = true;
        };
      };
  };
}
