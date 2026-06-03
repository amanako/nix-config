{
  nixvim.plugins.undotree = {user, ...}: {
    homeManager.programs.nixvim.plugins.undotree = {
      enable = true;
    };
  };
}
