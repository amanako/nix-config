{
  zen-browser.sync = {
    description = ''
      Aspect to configure Firefox Sync within zen browser.
    '';

    persistUser = {user, ...}: let
      basePath = ".config/zen/${user.userName}";
    in {
      directories =
        [
          "weave"
        ]
        |> map (dir: basePath + "/" + dir);

      files =
        [
          "signedInUser.json"
          "storage-sync-v2.sqlite"
          "synced-tabs.db"
        ]
        |> map (file: basePath + "/" + file);
    };
  };
}
