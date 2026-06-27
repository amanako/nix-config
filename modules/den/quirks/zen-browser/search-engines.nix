{
  den.quirks.zenSearchEngines = {
    description = ''
      Search engines built by zen user settings collector.
      They should be made an attribute named after engine with the following:

      Name: string - name displayed when searching with the engine
      Template: string - pattern used to search the engine: often contains {searchTerms} within
      icon: path - icon to be used for the search engine
      aliases: list - all aliases that can by typed on keyboard to start the engine - each list item should start with @
    '';
  };
}
