{
  den.aspects.editors._.neovim = {
    nixos = {
      # Should fix binary problems with mason/tree-sitter for example
      programs.nix-ld.enable = true;
    };

    homeManager =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      let
        configDir = "${config.home.homeDirectory}/nix-config/modules/aspects/editors/neovim/nvim";
      in
      {
        xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink configDir;
        # Fix for mkOutOfStoreSymlink to work
        stylix.targets.neovim.enable = lib.mkForce false;

        programs.neovim = {
          enable = true;
          withRuby = true;
          withPython3 = true;

          viAlias = true;
          vimAlias = true;

          plugins = with pkgs.vimPlugins; [
            lazy-nvim
            nvim-treesitter.withAllGrammars
          ];

          extraPackages = with pkgs; [
            # Tools
            wget
            fd
            tree-sitter
            wl-clipboard

            # Linters
            luajitPackages.luacheck

            # Compilers
            libclang

            # Formatters
            prettier
            stylua
            nixfmt

            # Other
            chafa
            cargo
            npm
          ];

          # Tips from https://codeberg.org/ryan4yin/nix-config/src/branch/main/home/base/tui/editors/neovim/default.nix
          extraWrapperArgs = with pkgs; [
            # LIBRARY_PATH is used by gcc before compilation to search directories
            # containing static and shared libraries that need to be linked to your program.
            "--suffix"
            "LIBRARY_PATH"
            ":"
            "${lib.makeLibraryPath [
              stdenv.cc.cc
              zlib
            ]}"

            # PKG_CONFIG_PATH is used by pkg-config before compilation to search directories
            # containing .pc files that describe the libraries that need to be linked to your program.
            "--suffix"
            "PKG_CONFIG_PATH"
            ":"
            "${lib.makeSearchPathOutput "dev" "lib/pkgconfig" [
              stdenv.cc.cc
              zlib
            ]}"
          ];
        };
      };
  };
}
