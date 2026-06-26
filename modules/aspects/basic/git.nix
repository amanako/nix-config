{
  den.aspects.basic.git = {
    hm = {user, ...}: {
      programs.git = {
        enable = true;
        settings = {
          user.name = user.git.username;
          user.email = user.git.email;
        };

        signing = {
          key = user.git.signingKey;
          signByDefault = true;
        };
      };
    };
  };
}
