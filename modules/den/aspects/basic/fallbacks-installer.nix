{
  den.aspects.basic.fallbacks-installer = {
    description = ''
      Installs the fallback program (from `preferences.fallbacks`) for preferences
      the user did not set, so consumers that fall back to a sensible default
      always find a program present on system.
    '';

    hm = {
      pkgs,
      user,
      lib,
      ...
    }: let
      install = key: let
        fallback = user.preferences.fallbacks.${key};
      in
        pkgs.${fallback} or (throw "no package named \"${fallback}\" in nixpkgs (fallback for preference `${key}`)");

      needed =
        user.preferences.fallbacks
        |> lib.filterAttrs (key: _: user.preferences.${key} == null);
    in {
      home.packages =
        needed
        |> lib.mapAttrsToList (key: _: install key);
    };
  };
}
