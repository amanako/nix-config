{ inputs, ... }:

{
  flake.modules.nixos.extraLocales-jp = {
    i18n.extraLocales = [
      "ja_JP.UTF-8/UTF-8"
    ];
  };
}
