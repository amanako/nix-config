{lib, ...}: {
  den.aspects.basic.no-primary-user-lockout = {
    hostConflicts.assertions = [
      ({host, ...}: [
        {
          target = "den.aspects.basic.no-primary-user-lockout";
          subject = ["No primary user"];
          assertion =
            host.users
            == {}
            || lib.any (user: user.isPrimaryUser) (lib.attrValues host.users);
          message = {
            target,
            subject,
          }: "[${target}]: ${subject |> lib.concatStringsSep ""}: No users will be set as primary ones on host ${host.name}. After installation this will cause trouble as there will be no one to build new generations.
          Please set at least one user as primary with isPrimaryUser option or remove users on ${host.name} altogether";
        }
      ])
    ];
  };
}
