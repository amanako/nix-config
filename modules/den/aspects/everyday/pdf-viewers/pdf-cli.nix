{
  den.aspects.everyday.pdf-viewers.pdf-cli = {
    hm = {pkgs, ...}: {
      home.packages = [pkgs.pdf-cli];
    };
  };
}
