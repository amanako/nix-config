{
  __findFile,
  inputs,
  ...
}: {
  imports = [(inputs.den.namespace "nixvim" false)];

  flake-file.inputs.nixvim.url = "github:nix-community/nixvim";

  nixvim.entry = {user, ...}: {
    persysUser.directories = [
      ".local/share/nvim"
      ".local/state/nvim"
    ];

    stylixHome.targets."nixvim".enable = false;
    nixos.xdg.mime.defaultApplications = {
      "text/*" = "nvim.desktop";
      "text/english" = "nvim.desktop";
      "text/html" = "nvim.desktop";
      "text/plain" = "nvim.desktop";
      "inode/directory" = "thunar.desktop";
      "x-scheme-handler/file" = "thunar.desktop";
      "application/octet-stream" = "zen-twilight.desktop";
    };

    homeManager = {user, ...}: {
      imports = [inputs.nixvim.homeModules.nixvim];

      xdg.dataFile."applications/nvim.desktop".text = ''
        [Desktop Entry]
        Name=Neovim
        Exec=${user.preferences.term} -e nvim
        Terminal=false
        Type=Application
        Keywords=Text;editor;
        Icon=nvim
        Categories=Utility;TextEditor;
        StartupNotify=false
      '';

      programs.nixvim = {
        enable = true;
        waylandSupport = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
        wrapRc = true;

        globals.mapleader = " ";
      };
    };
  };
}
