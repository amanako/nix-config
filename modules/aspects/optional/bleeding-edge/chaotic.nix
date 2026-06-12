{inputs, ...}: {
  flake-file = {
    inputs.chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    nixConfig = {
      extra-substituters = ["https://nyx-cache.chaotic.cx"];
      extra-trusted-public-keys = ["nyx-cache.chaotic.cx:dJxTrgMC3V3cFfyIiBQDQorG6k1LsqurH/srpMSq7qk="];
    };
  };

  den.aspects.optional.bleeding-edge.chaotic = {
    nixos = {
      imports = [
        inputs.chaotic.nixosModules.default
      ];
    };

    homeManager = {
      imports = [inputs.chaotic.homeManagerModules.default];
    };
  };
}
