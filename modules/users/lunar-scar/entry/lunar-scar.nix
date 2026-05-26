{
  den.hosts.x86_64-linux.nebula.users.lunar-scar = {
    git = let
      username = "abyssal-twilight";
    in {
      inherit username;
      # Tip from: https://docs.codeberg.org/git/configuring-git
      email = "${username}@noreply.codeberg.org";
      signingKey = "5CB7F18E1B212DB2";
    };

    niri.autoSpawnShell = "noctalia";

    awww = {
      script.args = [
        "--transition-fps 144"
        "--transition-type wave"
        "--transition-angle 225"
        "--resize=fit"
      ];
      script.label = "wallpaper-mix";

      service.calendar = "*-*-* *:00";
    };
  };
}
