{lib, ...}: {
  den.aspects.everyday.pdf-viewers.pdf-cli = {
    description = "A lightweight, fast and responsive terminal PDF/EPUB viewer with image support.";

    hm = {pkgs, ...}: let
      inherit (pkgs.pdf-cli) pname;
      desktop = "${pname}.desktop";
    in {
      home.packages = [pkgs.pdf-cli];

      xdg.desktopEntries."${pname}" = {
        name = pname;
        type = "Application";
        terminal = true;
        icon = "application-pdf";
        exec = lib.getExe pkgs.pdf-cli;
        comment = "A lightweight, fast and responsive terminal PDF/EPUB viewer with image support.";
        categories = ["Office"];
      };

      xdg.mimeApps = {
        enable = true;
        defaultApplications = lib.genAttrs [
          "application/pdf"
          "application/epub+zip"
          "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        ] (_: [desktop]);
      };
    };
  };
}

