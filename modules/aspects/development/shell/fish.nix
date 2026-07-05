{den, ...}: {
  den.aspects.shell.interpreters.fish = {
    stylixHMSettings.targets."fish".enable = false;

    persistUser.files = [
      ".local/share/fish/fish_history"
    ];

    # Sets fish for both nixos and homeManager
    includes = [
      (den.batteries.user-shell "fish")
    ];

    hm = {
      pkgs,
      lib,
      config,
      ...
    }: {
      programs.fish = {
        interactiveShellInit = ''
          set -U fish_greeting
          # Shell remains same when running "nix run" or "nix-shell"
          ${pkgs.any-nix-shell |> lib.getExe} fish --info-right | source
        '';
        shellAliases = {
          bios = "systemctl reboot --firmware-setup";
          # Literally replace cat with bat to keep bat config active
          cat = "bat";
          cd = "z";

          ls = "${config.programs.eza.package |> lib.getExe} --icons -a --group-directories-first";
          man = "${pkgs.bat-extras.batman |> lib.getExe}";
          rm = "rm -I";
        };
        plugins = [
          {
            name = "bass";
            inherit (pkgs.fishPlugins.bass) src;
          }
          {
            name = "fish-you-should-use";
            inherit (pkgs.fishPlugins.fish-you-should-use) src;
          }
          {
            name = "z";
            inherit (pkgs.fishPlugins.z) src;
          }
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
    };
  };
}
