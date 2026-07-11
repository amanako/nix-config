{lib, ...}: {
  den.schema.host = {
    options.disko.devices = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Disko device configuration.";
    };
  };
}
