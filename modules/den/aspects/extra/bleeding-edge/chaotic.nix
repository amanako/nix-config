{inputs, ...}: {
  flake-file = {
    inputs.chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    nixConfig = {
      extra-substituters = ["https://nyx-cache.chaotic.cx"];
      extra-trusted-public-keys = ["nyx-cache.chaotic.cx:dJxTrgMC3V3cFfyIiBQDQorG6k1LsqurH/srpMSq7qk="];
    };
  };

  den.aspects.extra.bleeding-edge.chaotic = {
    description = "Chaotic-CX Nyx overlay providing bleeding-edge and extra packages.";

    nixos.imports = [
      inputs.chaotic.nixosModules.default
      # Use the system pkgs (which carry our allowUnfreePredicate) as the base
      # for chaotic's jovian overlay instead of chaotic's own re-imported
      # nixpkgs. Since nixpkgs f13ff45, `nixpkgs.config` is a deferred module,
      # so `flakeNixpkgs.config` (default `pkgs.config`) no longer reaches
      # check-meta and unfree packages (e.g. jovian-chaotic.steam) are refused.
      # Cost: nyx's binary cache is not hit for these packages.
      {
        chaotic.nyx.overlay.onTopOf = "user-pkgs";
      }
    ];

    hm.imports = [
      inputs.chaotic.homeManagerModules.default
    ];
  };
}
