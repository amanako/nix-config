{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      host = "gitlab.io";
      hostname = "104.21.96.56";
    };
  };
}
