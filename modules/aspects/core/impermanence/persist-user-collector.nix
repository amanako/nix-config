{lib, ...}: {
  den.aspects.core.impermanence.persistUserCollector = let
    mkPersist = data: {
      directories = lib.unique (lib.concatMap (entries: entries.directories or []) data);
      files = lib.unique (lib.concatMap (entries: entries.files or []) data);
    };
  in
    {
      host,
      user,
      ...
    }:
      if user.impermanence.useHMModule
      then {
        homeManager = {persistUser, ...}: {
          home.persistence.${host.impermanence.persistenceDir} = mkPersist persistUser;
        };
      }
      else {
        nixos = {persistUser, ...}: {
          environment.persistence.${host.impermanence.persistenceDir}.users.${user.userName} = mkPersist persistUser;
        };
      };
}
