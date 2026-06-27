{
  den.aspects.basic.desktopEntriesCollector = {
    description = ''
      Collector which assembles all emitted desktop entries,
      flattens them to attribute sets of entries and passes them to xdg.desktopEntries in hm class.
    '';

    hm = {
      desktopEntries,
      lib,
      ...
    }: {
      xdg.desktopEntries =
        desktopEntries
        |> lib.foldl (acc: curr: curr |> lib.mergeAttrs acc) {};
    };
  };
}
