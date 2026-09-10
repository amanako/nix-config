{
  den.quirks.packageChannels = {
    description = ''
      Set the channel from which a package should be resolved. Format is
      `packageChannels.$PACKAGE_NAME = $CHANNEL`, where PACKAGE_NAME is the attribute
      name in nixpkgs and CHANNEL is a channel name (flake input name without the
      `nixpkgs-` prefix, e.g. `stable`), matching the values of `host.defaultChannel`.
    '';
  };
}