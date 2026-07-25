{
  den.aspects.dev.shells.nushell.config-collector = {
    description = ''
      Aspect assembling all extra config emitted by nushellConfig quirk.
    '';

    hm = {
      nushellConfig,
      lib,
      ...
    }: {
      programs.nushell.extraConfig =
        nushellConfig
        |> lib.unique
        |> lib.concatStringsSep "\n";
    };
  };
}
