{
  den.aspects.basic.preferences-installer = {
    description = "Handles pure user preferences by installing required packages to `home.packages`.";

    hm = {
      user,
      lib,
      pkgs,
      ...
    }: let
      cfg = user.preferences.monofont;
      fontPackage =
        lib.attrByPath (lib.splitString "." cfg.package)
        (throw "no package named \"${cfg.package}\" in nixpkgs (preferred font)")
        pkgs;
    in {
      home.packages = [fontPackage];
    };
  };
}
