{
  den.aspects.core.nix.nh = let
    args = {
      enable = true;

      clean = {
        dates = "weekly";
        enable = true;
        extraArgs = "--keep 10 --keep-since 5d --ask";
      };
    };
  in {
    description = ''
      From [README](https://github.com/nix-community/nh)
      NH is a modern helper utility that aims to consolidate and reimplement some of the commands
      and interfaces from various tools within the Nix/NixOS ecosystem. Our goal is to provide a
      cohesive, easily-understandable interface with more features, better ergonomics and at many
      times better speed.
    '';

    nix = {
      host,
      lib,
      ...
    }: {
      programs.nh =
        args
        |> lib.mergeAttrs {
          flake = host.repoRoot;
        };
    };

    hm = {
      user,
      lib,
      ...
    }: {
      programs.nh =
        args
        |> lib.mergeAttrs {
          flake = user.repoRoot;
        };
    };
  };
}
