{ inputs, ... }:

{
  flake-file.inputs = {
    ascii = {
      url = "git+https://codeberg.org/permafrozen/ascii";
      flake = false;
    };
  };

  den.aspects.shell = {
    nixos = {
      programs.fish.enable = true;
      programs.fzf.fuzzyCompletion = true;
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
        fd = lib.getExe pkgs.fd;
      in
      {
        programs.ssh.enable = true;
        programs.git.enable = true;

        programs.fzf = rec {
          enable = true;
          # Enables the following
          # <C-t> = fzf select
          # <C-r> = fzf history
          # Alt-c = fzf cd
          enableFishIntegration = true;
          defaultCommand = "${fd} --type file --follow --hidden --exclude .git";
          fileWidgetCommand = defaultCommand;
          defaultOptions = [
            "--ansi"
            "--border"
          ];
          colors = lib.mkDefault {
            fg = "#ebdbb2";
            bg = "#282828";
            hl = "#b16286";
            "fg+" = "#689d6a";
            "bg+" = "#32302f";
            "hl+" = "#d3869b";
            info = "#d65d0e";
            prompt = "#458588";
            pointer = "#fe8019";
            marker = "#8ec07c";
            spinner = "#cc241d";
            header = "#fabd2f";
          };
          tmux.enableShellIntegration = true;
        };

        programs.fastfetch = {
          enable = true;
          settings = builtins.fromJSON (builtins.readFile ./config.jsonc) // {
            logo = {
              type = "file";
              source = "${inputs.ascii.outPath}/src/nixos_logo.txt";
              color = {
                "1" = "blue";
              };
              padding = {
                top = 1;
                bottom = 0;
                left = 1;
                right = 2;
              };
              recache = true;
              chafa.fgOnly = true;
            };
          };
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
