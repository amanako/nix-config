{
  flake-file.inputs.vicinae-extensions.url = "github:vicinaehq/extensions";

  den.aspects.ui.launchers.vicinae.extensions = {
    hm = {inputs', ...}: {
      programs.vicinae.extensions = with inputs'.vicinae-extensions.packages; [
        nix
      ];
    };
  };
}
