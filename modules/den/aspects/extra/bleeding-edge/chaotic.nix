{inputs, ...}: {
  flake-file = {
    inputs.chaotic.url = "github:chaotic-cx/nyx/main";

    nixConfig = {
      extra-substituters = ["https://nyx-cache.chaotic.cx"];
      extra-trusted-public-keys = ["nyx-cache.chaotic.cx:dJxTrgMC3V3cFfyIiBQDQorG6k1LsqurH/srpMSq7qk="];
    };
  };

  den.aspects.extra.bleeding-edge.chaotic = {
    description = "Chaotic-CX Nyx overlay providing bleeding-edge and extra packages.";

    nixos.imports = [
      inputs.chaotic.nixosModules.default
    ];

    hm.imports = [
      inputs.chaotic.homeManagerModules.default
    ];
  };
}
