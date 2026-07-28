{
  den.quirks.conflicts = {
    description = ''
      Conflict declarations between aspects.
      An attrset with `warnings` and `assertions`, each a list of entries.
      Warning entry: { subject (list of strings), target (list of strings), message (string or { subject, target } -> string) }.
      Assertion entry: { subject (list of strings), target (list of strings), assertion (bool), message (string or { subject, target } -> string) }.
    '';
  };
}
