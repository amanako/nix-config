{
  den.aspects.utility.zathura = {
    homeManager = {lib, ...}: {
      programs.zathura = {
        enable = true;
        options = {
          # Evade blinding
          recolor = true;
          recolor-lightcolor = lib.mkDefault "#1e3a8a";
          recolor-darkcolor = lib.mkDefault "#e0f2fe";

          # Ability to copy selected text automatically to clipbaord.
          # Zathura doesn't support it out-of-the-box.
          selection-clipboard = "clipboard";
        };
      };
    };
  };
}
