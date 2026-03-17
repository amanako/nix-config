{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      host = "codeberg.org";
      user = "git";
      port = 22;
      identityFile = "~/.ssh/id_ed25519_codeberg";
    };
  };
}
