{lib, ...}: {
  den.aspects.core.impermanence.persist-user-collector = let
    mkPersist = data: {
      directories =
        data
        |> lib.concatMap (entries: entries.directories or [])
        |> lib.unique;

      files =
        data
        |> lib.concatMap (entries: entries.files or [])
        |> lib.unique;
    };
  in {
    hm = {
      host,
      persistUser,
      ...
    }: let
      cfg = host.settings.core.impermanence;
    in
      lib.optionalAttrs (!cfg.mountHomeDir) {
        home.persistence.${cfg.persistenceDir} = persistUser |> mkPersist;
      };

    nixos = {
      host,
      user,
      persistUser,
      ...
    }: let
      isInHM =
        user.classes
        |> lib.elem "homeManager";
      cfg = host.settings.core.impermanence;
    in
      lib.optionalAttrs (!isInHM && !cfg.mountHomeDir) {
        environment.persistence.${cfg.persistenceDir}.users.${user.userName} = persistUser |> mkPersist;
      };
  };
}
