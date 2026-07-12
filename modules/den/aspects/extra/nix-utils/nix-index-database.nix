{inputs, ...}: {
  flake-file.inputs.nix-index-database.url = "github:nix-community/nix-index-database";

  den.aspects.extra.nix-utils.nix-index-database = {
    hm = {
      imports = [
        inputs.nix-index-database.homeModules.default
      ];

      programs = {
        nix-index-database.comma.enable = true;

        jq.enable = true;
      };
    };
  };
}
