{ den, ... }:

{
  den.aspects.nebula = {
    includes = with den.aspects; [
      nebula._.hardware

      performance
      utility
    ];

    provides.to-users = {
      includes = [
        (den._.unfree [
          "nvidia-x11"
          "nvidia-settings"
          "steam"
          "steam-unwrapped"
          "rar"
          "unrar"
        ])
      ];
    };

    nixos = {
      home-manager.backupFileExtension = "backup";
    };
  };
}
