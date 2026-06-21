{
  den.schema.user = {
    host,
    user,
    lib,
    ...
  }: {
    options.impermanence = lib.mkOption {
      type = lib.types.submodule {
        options.useHMModule = let
          isInHMClass = lib.elem "homeManager" user.classes;
          inherit (host.impermanence) enableUser;
        in
          lib.mkOption {
            # If host doesn't allow for user directories persistence don't allow users to change the option
            # If it does, suppose users in homeManager class prefer using homeManager module
            default =
              if !enableUser
              then null
              else isInHMClass;
            # If host doesn't allow for user directories persistence make option readOnly
            # If it does only allow changing of option to users who are in homeManager class
            readOnly = !enableUser || !isInHMClass;
            type = lib.types.nullOr lib.types.bool;
            description = let
              inherit (host.impermanence) persistenceDir;
            in ''
              Whether to import and use homeManager attribute set for configuring mountspoints.
              This places persistence directories under `home.persistence.${persistenceDir}` in homeManager class
              instead of the usual `environment.persistence.${persistenceDir}`. There isn't any virtual difference
              for homeManager users, but they have a choice. Users not a part of the homeManager class may not change this option instead relying on host.
            '';
          };
      };
    };
  };
}
