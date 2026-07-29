{
  # Host-scope conflict declarations. Kept separate from `userConflicts` because
  # the host-aspects projection re-emits a host aspect's quirk keys into every
  # user scope. Folding host entries into the user-side `userConflicts` pipe
  # would resolve them against the user's Home Manager config (e.g. a
  # config-dependent assertion reading `config.disko` would throw). Host aspects
  # emit here; only the host schema's collector consumes it, so user scopes carry
  # the data inert.
  den.quirks.hostConflicts = {
    description = ''
      Host-scope conflict declarations between aspects.
      Same shape as `userConflicts`: An attrset with `warnings` and `assertions`, each a list of entries.
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
