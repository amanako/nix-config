{ config, pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [
    "amdgpu"
    "nvidia"
  ];

  hardware.nvidia = { 
    open = true;
    modesetting.enable = true;
    powerManagement.enable = true;
    nvidiaSettings = true;
    package = 
      let
        base = 
	  config.boot.kernelPackages.nvidiaPackages.latest;
	    cachyos-nvidia-patch = pkgs.fetchpatch {
	      url = "https://raw.githubusercontent.com/CachyOS/CachyOS-PKGBUILDS/master/nvidia/nvidia-utils/kernel-6.19.patch";
	      sha256 = "sha256-YuJjSUXE6jYSuZySYGnWSNG5sfVei7vvxDcHx3K+IN4=";
            };
	driveAttr = if config.hardware.nvidia.open then "open" else "bin";
      in
      base
      //  {
	  ${driveAttr} = base.${driveAttr}.overrideAttrs (oldAttrs : {
	    patches = (oldAttrs.patches or [ ]) ++
	      [ cachyos-nvidia-patch ];
	  });
	};
    prime = {
      #offload = {
      #  enable = true;
      #	enableOffloadCmd = true;
      #};
      sync.enable = true;

      # Hardware specific - check out https://nixos.wiki/wiki/Nvidia
      amdgpuBusId = "PCI:5:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
