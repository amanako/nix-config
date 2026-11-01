{
  den.aspects.basic.nscd-start-limit = {
    description = ''
      Disable start rate limiting for nscd - NSS lookup proxy
      for compatibility with programs using a different glibc -
      gets restarted several times during boot for unknown reason
      which can lead to a failed (start-limit-hit) state.
    '';
    nixos.systemd.services.nscd.unitConfig.StartLimitIntervalSec = 0;
  };
}
