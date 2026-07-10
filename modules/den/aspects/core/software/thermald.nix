{
  den.aspects.core.software.thermald = {
    nixos.services.thermald = {
      enable = true;
      debug = true;

      configFile = ./thermal-conf.xml;
    };
  };
}
