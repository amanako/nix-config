{
  nixvim.plugins.which-key = {user, ...}: {
    hm.programs.nixvim.plugins.which-key = {
      enable = true;
      settings = {
        delay = 200;
        expand = 1;
      };
    };
  };
}
