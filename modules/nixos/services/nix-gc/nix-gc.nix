{ inputs, ... }:

{
  # nh(nix-helper) is included to replace nix-gc and rebuild together
  flake.modules.nixos.nix-gc = {
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    nix.settings.auto-optimise-store = true;
  };
}
