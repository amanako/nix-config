{
  den.aspects.core.impermanence.persistSystemCollector = {
    nixos = {
      persistSystem,
      host,
      lib,
      ...
    }: let
      cfg = host.settings.core.impermanence;
    in {
      environment.persistence."${cfg.persistenceDir}" = {
        directories =
          persistSystem
          |> lib.concatMap (entries: entries.directories or [])
          |> lib.unique;
        files =
          persistSystem
          |> lib.concatMap (entries: entries.files or [])
          |> lib.unique;
      };
    };
  };
}
