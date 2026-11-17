{
  den.aspects.utilities.localsend = {
    description = "LocalSend — an open-source, cross-platform file sharing app.";

    nixos.programs.localsend = {
      enable = true;
      openFirewall = true;
    };
  };
}
