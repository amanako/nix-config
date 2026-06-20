{
  den.aspects.core.boot.optional.plymouth = {
    description = ''
      From [ArchWiki](https://wiki.archlinux.org/title/Plymouth):
      Plymouth is a project from Fedora and now listed among the freedesktop.org's
      official resources providing a flicker-free graphical boot process. It relies
      on kernel mode setting (KMS) to set the native resolution of the display as
      early as possible, then provides an eye-candy splash screen leading all the
      way up to the login manager.
    '';

    stylixNixOSSettings.targets."plymouth".enable = false;

    nixos = {pkgs, ...}: {
      boot.plymouth = {
        enable = true;
        theme = "nixos-bgrt";
        themePackages = [
          # Simple and minimal
          pkgs.nixos-bgrt-plymouth
        ];
      };
    };
  };
}
