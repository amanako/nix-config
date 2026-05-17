{den, ...}: {
  den.hosts.x86_64-linux.nebula.users.lunar-scar = {
    git = let
      username = "abyssal-twilight";
    in {
      inherit username;
      # Tip from: https://docs.codeberg.org/git/configuring-git
      email = "${username}@noreply.codeberg.org";
      signingKey = "5CB7F18E1B212DB2";
    };
  };
}
