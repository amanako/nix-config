{
  inputs,
  den,
  ...
}:

{
  den.aspects.nebula = {
    includes = [
      (den._.unfree [
        "steam"
        "steam-unwrapped"
        "nvidia-x11"
        "nvidia-settings"
        "unrar"
      ])
    ];

    os.networking.hostName = "nebula";

    nixos = {

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
    };

    # Home manager overrides
    homeManager = {
      #imports = with inputs.self.hmModules; [
      #];
    };
  };
}
