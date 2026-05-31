{
  den.aspects.nix.lix = {
    description = ''
      From [official site](https://lix.systems):
      Lix is a modern, delicious implementation of the Nix package manager,
      focused on correctness, usability, and growth – and committed to doing right by its community.
    '';

    nixos = {pkgs, ...}: {
      # Ensure lix completely changes nix on all fields
      nixpkgs.overlays = [
        (final: prev: {
          inherit
            (prev.lixPackageSets.latest)
            nixpkgs-review
            nix-eval-jobs
            nix-fast-build
            colmena
            ;
        })
      ];

      nix.package = pkgs.lixPackageSets.latest.lix;
    };
  };
}
