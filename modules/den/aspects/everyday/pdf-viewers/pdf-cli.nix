{lib, ...}: {
  den.aspects.everyday.pdf-viewers.pdf-cli = {
    description = "A lightweight, fast and responsive terminal PDF/EPUB viewer with image support.";

    hm = {pkgs, ...}: {
      home.packages = [pkgs.pdf-cli];

      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "application/pdf" = "pdf-cli.desktop";
          "application/epub+zip" = "pdf-cli.desktop";
          "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "pdf-cli.desktop";
        };
      };
    };
  };
}
