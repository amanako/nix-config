{
  den,
  inputs,
  ...
}: {
  den.aspects.extra.stylix-user = {
    includes = [den.aspects.extra.stylix-user.base-settings];

    # Stylix uses outdated option renamed by upstream
    # Without this emits warning: "The option `programs.rofi.font' defined in ... has been renamed to `programs.rofi.settings.font`.
    # TODO: Remove when upstream merges fix.
    stylixHMSettings.targets.rofi.enable = false;

    hm = {
      host ? null,
      stylixHMSettings,
      lib,
      ...
    }: let
      hostImportedModule = host != null && host.settings.extra.stylix-host or {} != {};
      mergeWithDefaults = settings:
        settings
        ++ [
          {
            enable = lib.mkDefault true;
            autoEnable = true;
            enableReleaseChecks = false;
          }
        ]
        |> lib.mkMerge;
    in {
      # If host included stylix-host aspect don't include home module pulled in by stylix's NixOS module.
      imports = lib.optional (!hostImportedModule) inputs.stylix.homeModules.stylix;

      stylix = stylixHMSettings |> mergeWithDefaults;
    };
  };
}
