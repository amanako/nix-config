{ lib, config, ... }:

{
  config = {
    i18n.defaultLocale = "en_US.UTF-8";
    lib.mkIf = config.enableExtraLocale {
      imports = [ ./extra.nix ];
    };
    enableExtraLocale = lib.mkForce true;
  };

  options.enableExtraLocale = lib.mkOption {
    default = false;
    type = lib.types.bool;
    description = "Whether to enable ja_JP UTF-8 locale";
  };
}
