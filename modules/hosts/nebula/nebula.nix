{
  inputs,
  den,
  ...
}:

{
  den.aspects.nebula =
    { lib, ... }:
    {
      nixos = {
        networking.hostName = "nebula";
        time.timeZone = "Europe/Paris";
        i18n.defaultLocale = "en_US.UTF-8";

        imports = with inputs.self.modules.nixos; [
          nebula-hw
          ly
        ];

        # Enable programs for proper functionality
        # Should also be enabled for each user individually
        programs.niri.enable = true;
        programs.fish.enable = true;

        home-manager.useGlobalPkgs = true;

        # Allow following unfree software for every user on the host
        nixpkgs.config.allowUnfreePredicate =
          pkg:
          builtins.elem (lib.getName pkg) [
            "steam"
            "steam-unwrapped"
            "nvidia-x11"
            "nvidia-settings"
            "unrar"
          ];
      };

      # Home manager overrides
      homeManager = {
        imports = with inputs.self.hmModules; [
        ];
      };
    };
}
