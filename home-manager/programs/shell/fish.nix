{ config, lib, pkgs, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -U fish_greeting
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
    '';
    shellAliases = {
      bios = "systemctl reboot --firmware-setup";
      cat = "${lib.getExe config.programs.bat.package}";
      cd = "z";
      ls = "${lib.getExe config.programs.eza.package} --icons -a --group-directories-first";
      man = "${lib.getExe pkgs.bat-extras.batman}";
      rm = "rm -I";
      rebuild = "sudo nixos-rebuild switch";
      flake-u = "sudo nix flake update";
    };
    # To be added with home-manager
    plugins = [
      {
				name = "fzf-fish";
				inherit (pkgs.fishPlugins.fzf-fish) src;
      }
      {
				name = "git";
        inherit (pkgs.fishPlugins.plugin-git) src;
      }
      {
				name = "done";
        inherit (pkgs.fishPlugins.done) src;
      }
    ];
  };
}
