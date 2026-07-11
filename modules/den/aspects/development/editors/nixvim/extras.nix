{
  nixvim.extras = {user, ...}: {
    hm.programs.nixvim.clipboard.providers.wl-copy.enable = true;
  };
}
