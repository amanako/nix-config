{
  den.aspects.shell = {
    nixos = {
      programs.fish.enable = true;
    };

    homeManager =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      let
        nh = lib.getExe pkgs.nh;
      in
      {
        programs.ssh.enable = true;
        programs.git.enable = true;

        programs.fzf = {
          enable = true;
          # Enables the following
          # <C-t> = fzf select
          # <C-r> = fzf history
          # Alt-c = fzf cd
          enableFishIntegration = true;
          defaultOptions = [
            "--border"
          ];
        };

        programs.zoxide = {
          enable = true;
          enableFishIntegration = true;
        };

        programs.eza = {
          enable = true;
          enableFishIntegration = true;
          icons = "always";
        };

        programs.fish = {
          enable = true;
          interactiveShellInit = ''
            set -U fish_greeting
            ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
          '';
          shellAliases = {
            bios = "systemctl reboot --firmware-setup";
            cat = "${lib.getExe config.programs.bat.package} --theme=ansi";
            cd = "z";

            ls = "${lib.getExe config.programs.eza.package} --icons -a --group-directories-first";
            man = "${lib.getExe pkgs.bat-extras.batman}";
            rm = "rm -I";
            rebuild = "${nh} os switch --ask --diff always --show-trace";
            clean = "${nh} clean all --keep 4 --optimise";
            search = "${nh} search";
            # Updates all flake inputs by default, a single one can be passed as well
            fup = "nix flake update --flake ${config.home.sessionVariables.NH_FLAKE}";
            fcheck = "nix flake check --accept-flake-config ${config.home.sessionVariables.NH_FLAKE}";
          };
          plugins = [
            {
              name = "bass";
              src = pkgs.fishPlugins.bass.src;
            }
            {
              name = "fish-you-should-use";
              src = pkgs.fishPlugins.fish-you-should-use.src;
            }
            {
              name = "z";
              src = pkgs.fishPlugins.z.src;
            }
            {
              name = "fzf-fish";
              src = pkgs.fishPlugins.fzf-fish.src;
            }
            {
              name = "git";
              src = pkgs.fishPlugins.plugin-git.src;
            }
            {
              name = "done";
              src = pkgs.fishPlugins.done.src;
            }
          ];
        };
      };
  };
}
