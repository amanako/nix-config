{ ... }:

{
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
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
