{
  den.aspects.core.power-management.thermald = {
    nixos.services.thermald = {
      enable = true;
      debug = true;

      configFile = ./thermal-conf.xml;
    };
  };
}
