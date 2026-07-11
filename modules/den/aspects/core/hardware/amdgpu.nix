{
  den.aspects.core.hardware.amdgpu = {
    nixos = {
      host,
      pkgs,
      lib,
      ...
    }: let
      cfg = host.settings.core.hardware;
      hasAmdgpu =
        cfg.gpus
        |> map (gpu: gpu.manufacturer)
        |> lib.elem "amdgpu";
    in
      lib.optionalAttrs hasAmdgpu {
        environment.systemPackages = [
          pkgs.lact
        ];
        systemd.packages = [pkgs.lact];
        systemd.services.lactd.wantedBy = ["multi-user.target"];
        services.lact.enable = true;

        hardware = {
          graphics = {
            enable = true;
            enable32Bit = true;
          };

          amdgpu = {
            initrd.enable = true;
            overdrive.enable = true;
          };

          firmware = [
            pkgs.linux-firmware
          ];
        };
      };
  };
}
