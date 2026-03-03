{ git, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user.name = git.name;
      user.email = git.email;
    };
  };
}
