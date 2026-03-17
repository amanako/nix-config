{ inputs, ... }:

{
  den.hosts.x86_64-linux = {
    nebula = {
      aspect = "nebula";
      users.lunar-scar.classes = [ "homeManager" ];
    };
  };
}
