{
  den.aspects.basic.remove-login-timeout = {
    nixos.services.logind.settings.Login.UserStopDelaySec = 0;
  };
}
