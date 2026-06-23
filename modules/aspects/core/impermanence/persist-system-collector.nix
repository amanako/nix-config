{
  den.aspects.core.impermanence.persistSystemCollector = {
    nixos = {
      persistSystem,
      host,
      lib,
      ...
    }: {
      environment.persistence."${host.impermanence.persistenceDir}" = {
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
