{
  den.aspects.core.impermanence.persistSystemCollector = {
    nixos = {
      persistSystem,
      host,
      lib,
      ...
    }: {
      environment.persistence."${host.impermanence.persistenceDir}" = {
        directories = lib.concatMap (entries: entries.directories or []) persistSystem;
        files = lib.concatMap (entries: entries.files or []) persistSystem;
      };
    };
  };
}
