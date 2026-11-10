{
  nixvim.plugins.lint = {
    hm = {pkgs, ...}: {
      programs.nixvim.plugins.lint = {
        enable = true;
        lintersByFt = {
          nix = ["statix"];
          cpp = ["clangtidy"];
        };

        autoInstall = {
          enable = true;
          # Won't be captured by getPackageOrStateByName.
          overrides.clangtidy = pkgs.clang-tools;
        };
      };
    };
  };
}
