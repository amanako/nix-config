{
  den.aspects.extra.gaming.lutris = {
    description = ''
      Lutris is a video game preservation platform aiming to
      keep your video game collection up and running for the years to come.
    '';

    # Settings, banners, games, runners, runtime packages etc.
    persistUser.directories = [
      ".local/share/lutris"
    ];

    hm = {pkgs, ...}: {
      # Regular lutris package (pkgs.lutris) enables steam support.
      # This will crash if steam is not in unfree predicate builder, like in `den.aspects.extra.gaming.steam`.
      # This is likely unwanted, so use free version which doesn't fail.
      home.packages = [
        pkgs.lutris-free
      ];
    };
  };
}
