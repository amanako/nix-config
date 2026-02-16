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
      #cd = "z";
      ls = "${lib.getExe config.programs.eza.package} --icons -a --group-directories-first -o -@";
      man = "${lib.getExe pkgs.bat-extras.batman}";
      rm = "rm -I";
    };
    # To be added with home-manager
    plugins = [
    #{
    #  name = "done";
    #  inherit (pkgs.fishPlugins.done) src;
    #}
    #{
    #  name = "git";
    #  inherit (pkgs.fishPlugins.plugin-git) src;
    #}
    #{
    #  name = "fzf-fish";
    #  inherit (pkgs.fishPlugins.fzf-fish) src;
    #}
      #{
      #  name = "z";
      #  src = pkgs.fetchFromGitHub {
      #    owner = "jethrokuan";
      #    repo = "z";
      #    rev = "ddeb28a7b6a1f0ec6dae40c636e5ca4908ad160a";
      #    sha256 = "0c5i7sdrsp0q3vbziqzdyqn4fmp235ax4mn4zslrswvn8g3fvdyh";
      #  };
      #}
    ];
  };
}
