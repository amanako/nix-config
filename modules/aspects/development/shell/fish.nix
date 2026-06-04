{den, ...}: {
  den.aspects.shell.interpreters.fish = {user, ...}: {
    stylix.targets."fish".enable = false;
    stylixHome.targets."fish".enable = false;

    persysUser.files = [
      ".local/share/fish/fish_history"
    ];

    # Sets fish for both nixos and homeManager
    includes = [
      (den.batteries.user-shell "fish")
    ];

    homeManager = {
      user,
      pkgs,
      lib,
      config,
      ...
    }: let
      nh = lib.getExe pkgs.nh;
    in {
      programs.fish = {
        interactiveShellInit = ''
          set -U fish_greeting
          # Shell remains same when running "nix run" or "nix-shell"
          ${lib.getExe pkgs.any-nix-shell} ${pkgs.fish} --info-right | source
        '';
        shellAliases = {
          bios = "systemctl reboot --firmware-setup";
          # Literally replace cat with bat to keep bat config active
          cat = "bat";
          cd = "z";

          ls = "${lib.getExe config.programs.eza.package} --icons -a --group-directories-first";
          man = "${lib.getExe pkgs.bat-extras.batman}";
          rm = "rm -I";
          rebuild = "${nh} os switch --accept-flake-config --ask --diff always --show-trace";
          clean = "${nh} clean all --keep 5 --optimise";
          search = "${nh} search";
          # Updates all flake inputs by default, a single one can be passed as well
          fup = "nix --accept-flake-config flake update --flake ${user.repoRoot}";
          fcheck = "nix --accept-flake-config flake check -L ${user.repoRoot}";
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
