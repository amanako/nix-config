{
  den.quirks.userConflicts = {
    description = ''
      User-scope conflict declarations between aspects.
      An attrset with `warnings` and `assertions`, each a list of entries.

      Warning entry: attribute set of:
      - subject (list of strings)
      - target (list of strings)
      - message (string or { subject, target } -> string).

      Assertion entry: attribute set of:
      - subject (list of strings)
      - target (list of strings)
      - assertion (bool)
      - message (string or { subject, target } -> string).
    '';
  };
}
