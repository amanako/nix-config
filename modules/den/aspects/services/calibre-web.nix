{
  den,
  lib,
  ...
}: let
  inherit
    (lib)
    mkOption
    types
    ;
in {
  den.aspects.services.calibre-web = {
    description = ''
      Calibre-Web book server. Its Calibre database lives in the `calibre`
      subdirectory of the shared library, leaving the library root free for
      loose documents that are synced but not indexed by Calibre.
    '';

    includes = [
      den.aspects.services.book-library
    ];

    persistHost.directories = ["/var/lib/calibre-web"];

    hostSettings = {
      listenPort = mkOption {
        type = types.port;
        default = 8083;
        description = "Local TCP port for Calibre-Web. Expose it with `services.calibre-web-serve` rather than opening it directly.";
      };

      enableUploads = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = "Whether books can be added to the library through the Calibre-Web interface.";
      };
    };

    nixos = {
      host,
      config,
      ...
    }: let
      cfg = host.settings.services.calibre-web;
      library = host.settings.services.book-library;
      calibreLibrary = "${library.path}/calibre";
    in {
      services.calibre-web = {
        enable = true;

        listen = {
          ip = "127.0.0.1";
          port = cfg.listenPort;
        };

        options = {
          calibreLibrary = calibreLibrary;
          enableBookUploading = cfg.enableUploads;
          enableBookConversion = true;
        };
      };

      users.users.calibre-web.extraGroups = ["books"];

      # Calibre-Web refuses to start without an existing metadata.db, so create
      # an empty Calibre library on first boot before the web app is started.
      systemd.services.calibre-library-init = {
        description = "Initialize the Calibre library database";
        wantedBy = ["multi-user.target"];
        before = ["calibre-web.service"];
        serviceConfig = {
          Type = "oneshot";
          User = "calibre-web";
          Group = "books";
          UMask = "0007";
        };
        script = ''
          if [ ! -f ${lib.escapeShellArg "${calibreLibrary}/metadata.db"} ]; then
            ${lib.getExe' config.services.calibre-web.calibrePackage "calibredb"} \
              --with-library ${lib.escapeShellArg calibreLibrary} \
              add --empty --title "Welcome — safe to delete"
          fi
        '';
      };
    };
  };
}
