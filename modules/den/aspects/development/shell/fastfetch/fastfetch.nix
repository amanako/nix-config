{inputs, ...}: {
  flake-file.inputs.ascii-art = {
    url = "gitlab:ntgn/ascii-art";
    flake = false;
  };

  den.aspects.shell.fastfetch = {
    hm = {lib, ...}: {
      programs.fastfetch = {
        enable = true;
        settings =
          ./config.jsonc
          |> builtins.readFile
          |> builtins.fromJSON
          |> lib.recursiveUpdate {
            logo = {
              type = "file";
              source = "${inputs.ascii-art.outPath}/src/legacy/nixos_logo.txt";
            };
          };
      };
    };
  };
}
