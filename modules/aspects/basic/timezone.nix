{
  den.aspects.basic.timezone = {
    nixos = {host, ...}: {
      time.timeZone = host.timeZone or "UTC";
    };
  };
}
