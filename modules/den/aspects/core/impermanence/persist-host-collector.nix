{
  den.aspects.core.impermanence.persist-host-collector = {
    nixos = {
      persistHost,
      host,
      lib,
      ...
    }: let
      cfg = host.settings.core.impermanence;
    in {
      environment.persistence."${cfg.persistenceDir}" = {
        directories =
          persistHost
          |> lib.concatMap (entries: entries.directories or [])
          |> lib.unique;
        files =
          persistHost
          |> lib.concatMap (entries: entries.files or [])
          |> lib.unique;
      };
    };
  };
}
