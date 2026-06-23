{
  den.aspects.core.hardware.amdgpu = {
    nixos = {
      host,
      pkgs,
      lib,
      ...
    }: let
      hasAmd =
        host.gpus
        |> map (gpu: gpu.type)
        |> lib.elem "amd";
    in
      lib.optionalAttrs hasAmd {
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
