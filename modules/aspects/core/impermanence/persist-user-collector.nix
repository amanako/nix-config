{lib, ...}: {
  den.aspects.core.impermanence.persistUserCollector = let
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
  in
    {
      host,
      user,
      ...
    }:
      if (user.impermanence.useHMModule == null)
      then {}
      else if user.impermanence.useHMModule
      then {
        homeManager = {persistUser, ...}: {
          home.persistence.${host.impermanence.persistenceDir} = persistUser |> mkPersist;
        };
      }
      else {
        nixos = {persistUser, ...}: {
          environment.persistence.${host.impermanence.persistenceDir}.users.${user.userName} = persistUser |> mkPersist;
        };
      };
}
