{ inputs, ... }:

{
  flake-file.inputs = {
    ascii-art = {
      url = "gitlab:ntgn/ascii-art";
      flake = false;
    };
  };

  den.aspects.shell = {
    nixos = {
      programs.fish.enable = true;
      programs.fzf.fuzzyCompletion = true;
    };

    persysUser = {
      directories = [
        {
          directory = ".ssh";
          mode = "0600";
        }
        {
          directory = ".gnupg";
          mode = "0600";
        }

        ".local/share/zoxide" # preserve zoxide database
      ];

      files = [
        ".bash_history"
        ".local/share/fish/fish_history"
      ];
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
        defaultCommand = "${fd} --type file --follow --hidden --exclude .git";
      in
      {
        programs.ssh.enable = true;
        programs.git.enable = true;

        stylix.targetsToDisable = [ "fzf" ];

        programs.fzf = {
          enable = true;
          # Enables the following
          # <C-t> = fzf select
          # <C-r> = fzf history
          # Alt-c = fzf cd
          enableFishIntegration = true;
          defaultCommand = defaultCommand;
          fileWidgetCommand = defaultCommand;
          defaultOptions = [
            "--ansi"
            "--border"
          ];
          colors = lib.mkDefault {
            fg = "#d4be98";
            bg = "#282626";

            hl = "#d3869b"; # magenta highlight (matches your accents)

            "fg+" = "#d4be98";
            "bg+" = "#32302f"; # selection background
            "hl+" = "#e78a4e"; # stronger highlight (orange)

            info = "#89b482"; # cyan-ish info line
            prompt = "#7daea3"; # blue prompt
            pointer = "#ea6962"; # red pointer (nice contrast)
            marker = "#a9b665"; # green multi-select
            spinner = "#d8a657"; # yellow spinner
            header = "#d3869b"; # magenta header
          };
        };

        programs.fastfetch = {
          enable = true;
          settings = lib.recursiveUpdate (builtins.fromJSON (builtins.readFile ./config.jsonc)) {
            logo = {
              type = "file";
              source = "${inputs.ascii-art.outPath}/src/legacy/nixos_logo.txt";
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

        programs.bat = {
          enable = true;
          config = {
            theme = lib.mkDefault "ansi";
            style = "full";
            italic-text = "always";
          };
          extraPackages = with pkgs.bat-extras; [
            # Integration for various programs
            core
          ];
        };

        programs.fish = {
          enable = true;
          interactiveShellInit = ''
            set -U fish_greeting
            # Shell remains same when running "nix run" or "nix-shell"
            ${lib.getExe pkgs.any-nix-shell} fish --info-right | source
          '';
          shellAliases = {
            bios = "systemctl reboot --firmware-setup";
            # Literally replace cat with bat to keep bat config active
            cat = "bat";
            cd = "z";

            ls = "${lib.getExe config.programs.eza.package} --icons -a --group-directories-first";
            man = "${lib.getExe pkgs.bat-extras.batman}";
            rm = "rm -I";
            rebuild = "${nh} os switch --ask --diff always --show-trace";
            clean = "${nh} clean all --keep 5 --optimise";
            search = "${nh} search";
            # Updates all flake inputs by default, a single one can be passed as well
            fup = "nix flake update --flake ${config.home.sessionVariables.NH_FLAKE}";
            fcheck = "nix flake check -L --accept-flake-config ${config.home.sessionVariables.NH_FLAKE}";
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
