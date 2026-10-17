{lib, ...}: let
  inherit
    (lib)
    mkOption
    types
    ;
in {
  den.aspects.services.book-library = {
    description = "Shared root for books and documents, group-writable for the Syncthing and Calibre-Web service users.";

    hostSettings = {
      path = mkOption {
        type = types.path;
        example = "/mnt/ssd/library";
        description = ''
          Directory holding the shared library. It can be pointed
          at a dedicated disk mount when one is available.
        '';
      };
    };

    persistHost = {host, ...}: {
      directories = [host.settings.services.book-library.path];
    };

    nixos = {host, ...}: let
      cfg = host.settings.services.book-library;
    in {
      users.groups.books = {};

      systemd.tmpfiles.settings."10-book-library".${cfg.path} = {
        d = {
          user = "root";
          group = "books";
          mode = "2770";
        };
      };
    };
  };
}
