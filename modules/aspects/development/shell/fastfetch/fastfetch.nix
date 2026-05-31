{inputs, ...}: {
  flake-file.inputs.ascii-art = {
    url = "gitlab:ntgn/ascii-art";
    flake = false;
  };

  den.aspects.shell.fastfetch = {
    homeManager = {lib, ...}: {
      programs.fastfetch = {
        enable = true;
        settings = lib.recursiveUpdate (builtins.fromJSON (builtins.readFile ./config.jsonc)) {
          logo = {
            type = "file";
            source = "${inputs.ascii-art.outPath}/src/legacy/nixos_logo.txt";
          };
        };
      };
    };
  };
}
