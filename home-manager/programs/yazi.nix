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
        show_hidden = true;
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
