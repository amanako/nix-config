{
  den.aspects.basic.preferences-installer = {
    description = ''
      Installs the nixpkgs package backing each user preference so consumers that
      fall back to a sensible default always find a program present on the system.

      A role resolves to the explicit `preferences` program when set, otherwise to
      its `preferences.fallbacks` program. The package is looked up in nixpkgs,
      honouring `preferences.binaries` so binary-style names (e.g. `nvim` for
      `neovim`, `hx` for `helix`) resolve to their package. A set preference whose
      program is not a nixpkgs package is assumed to be provided by an aspect and is skipped,
      whereas an unresolvable fallback is an error.
    '';

    hm = {
      host,
      user,
      lib,
      pkgs,
      ...
    }: let
      inherit (host.settings.core.hardware) deviceType;

      lookup = name: lib.attrByPath (lib.splitString "." name) null pkgs;

      toPackage = program: let
        candidates =
          [program]
          ++ (user.preferences.binaries
            |> lib.filterAttrs (_: binary: binary == program)
            |> lib.attrNames);
      in
        candidates
        |> lib.map lookup
        |> lib.findFirst (package: package != null) null;

      fontPackage =
        lib.attrByPath (lib.splitString "." user.preferences.monofont.package)
        (throw "no package named \"${user.preferences.monofont.package}\" in nixpkgs (preferred font)")
        pkgs;

      rolePackages =
        user.preferences.fallbacks
        |> lib.mapAttrsToList (role: fallback: let
          preference = user.preferences.${role};
          isFallback = preference == null;
          program =
            if isFallback
            then fallback
            else preference;
          package = toPackage program;
        in
          if package != null
          then package
          else if isFallback
          then throw "no package named \"${fallback}\" in nixpkgs (fallback for preference `${role}`)"
          else null);
    in {
      home.packages =
        if (deviceType == "server")
        then []
        else
          (lib.unique (
            [fontPackage]
            ++ (rolePackages |> lib.filter (package: package != null))
          ));
    };
  };
}
