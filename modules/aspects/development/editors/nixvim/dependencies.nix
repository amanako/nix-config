{
  nixvim.dependencies = {
    hm.programs.nixvim.dependencies = {
      git.enable = true;
      ripgrep.enable = true;
      fd.enable = true;
    };
  };
}
