{ inputs, ... }:

{
  flake-file.inputs = {
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  den.aspects.dev._.neovim = {
    nixos = {
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
        configDir = "${config.home.homeDirectory}/nix-config/modules/aspects/dev/nvim/nvim";
        overlays = [ inputs.neovim-nightly-overlay.overlays.default ];
      in
      {
        xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink configDir;
        stylix.targets.neovim.enable = false;

        nixpkgs.overlays = overlays;

        programs.neovim = {
          enable = true;
          viAlias = true;
          vimAlias = true;
          waylandSupport = true;
          package = pkgs.neovim-unwrapped;
          plugins = [
            pkgs.vimPlugins.nvim-treesitter.withAllGrammars
          ];

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

        home.packages = with pkgs; [
          fd
          stylua
          chafa
          tree-sitter
          clang
          dwt1-shell-color-scripts
          gh
        ];
      };
  };
}
