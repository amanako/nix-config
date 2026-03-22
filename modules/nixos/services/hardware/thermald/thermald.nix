{ inputs, ... }:

{
  # Goes along very well with auto-cpufreq and is intended to be used alongside
  flake.modules.nixos.thermald = {
    services.thermald.enable = true;
  };
}
