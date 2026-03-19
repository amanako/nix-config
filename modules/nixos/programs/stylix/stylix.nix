{ inputs, ... }:

{
  flake.modules.nixos.stylix =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      defaultTargetsToDisable = [
        "fish"
      ];
      eligibleTargets = lib.filterAttrs (name: _: lib.hasAttrs name config.stylix.targets) (
        lib.genAttrs defaultTargetsToDisable
      );
    in
    {
      imports = [ inputs.stylix.nixosModules.stylix ];

      stylix = {
        enable = true;
        autoEnable = false;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";
        polarity = "dark";

        icons = {
          enable = true;
          package = pkgs.papirus-icon-theme;

          dark = "Papirus-Dark";
          light = "Papirus-Light";
        };

        fonts = {
          monospace = {
            package = pkgs.nerd-fonts.victor-mono;
            name = "Victor Mono NF";
          };
        };

        # TODO: Implement removal for eligibleTargets
        #targets = lib.genAttrs eligibleTargets (_: {
        #  enable = false;
        #});
      };
    };
}
