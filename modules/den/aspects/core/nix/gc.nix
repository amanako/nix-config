{
  den.aspects.core.nix.gc = let
    gc = {
      automatic = true;
      dates = "weekly";
      persistent = true;
      options = "--delete-older-than 7d --ask";
    };
  in {
    description = ''
      Gc = garbage collection.
      Periodical removal of outdated files in order to preserve disk space.
    '';

    nixos.nix.gc = gc;
    hm.nix.gc = gc;
  };
}
