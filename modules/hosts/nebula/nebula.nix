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
        programs.niri.enable = true;
        programs.fish.enable = true;
        programs.gamemode.enable = true;
        programs.gamemode.enableRenice = true;

        # Allow following unfree software for everyone on the host
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
          niri
        ];

        #home.sessionVariables = {
        #  EDITOR = "nvim";
        #  TERM = "kitty";
        #  GTK_IM_MODULE = "fcitx";
        #  QT_IM_MODULE = "fcitx";
        #};
      };
    };
}
