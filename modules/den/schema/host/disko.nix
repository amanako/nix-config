{
  den.schema.host = {lib, ...}: {
    options.disko.devices = lib.mkOption {
      type = lib.types.attrs;
      description = "Disko device configuration";
      default = {};
    };
  };
}
