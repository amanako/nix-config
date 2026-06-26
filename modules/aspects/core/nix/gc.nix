{
  den.aspects.core.nix.gc = let
    gc = {
      automatic = true;
      dates = "weekly";
      persistent = true;
      options = "--delete-older-than 7d --ask";
    };
  in {
    nixos.nix.gc = gc;
    hm.nix.gc = gc;
  };
}
