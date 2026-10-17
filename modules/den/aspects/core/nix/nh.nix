{
  den.aspects.core.nix.nh = let
    args = {
      enable = true;

      clean = {
        enable = true;
        dates = "weekly";
        extraArgs = "--keep 10 --keep-since 5d";
      };
    };

    setup = entity:
      args
      // {
        flake = entity.repoRoot;
      };
  in {
    description = ''
      NH is a modern helper utility that aims to consolidate and reimplement some of the commands
      and interfaces from various tools within the Nix/NixOS ecosystem.
    '';

    nixos = {host, ...}: {
      programs.nh = setup host;
    };

    hm = {user, ...}: {
      programs.nh = setup user;
    };
  };
}
