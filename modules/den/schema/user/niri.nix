{
  den.schema.user = {lib, ...}: {
    options.niri.autoSpawnShell = lib.mkOption {
      type = lib.types.enum [
        "none"
        "noctalia"
        "dms"
      ];
      default = "none";
      example = "noctalia";
      description = "Which shell to automatically spawn when starting niri.";
    };
  };
}
