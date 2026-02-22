{ ... }:

{
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    shellWrapperName = "y";
    keymap = {
      mgr.prepend_keymap = [];
    };
    settings = {
      mgr = {
        show_hidden = false;
      };
      opener.edit = [
        {
          run = "nvim \"$@\"";
          block = true;
        }
      ];
    };
  };
}
