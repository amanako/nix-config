{
  nixvim.plugins.trouble = {user, ...}: {
    homeManager.programs.nixvim.plugins.trouble = {
      enable = true;
      auto_close = true;
      auto_jump = true;
      auto_refresh = true;
      focus = true;
    };
  };
}
