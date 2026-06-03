{
  nixvim.plugins.which-key = {user, ...}: {
    homeManager.programs.nixvim.plugins.which-key = {
      enable = true;
      settings = {
        delay = 200;
        expand = 1;
      };
    };
  };
}
