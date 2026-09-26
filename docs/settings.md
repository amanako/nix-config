# Settings (`userSettings` / `hostSettings`)

The generator implemented in `modules/den/schema/{user,host}/settings.nix`
(`skipKey` / `reshapeSettings` / `hasSettingsDeep` / `nodeModule`) is adapted
from sini's
[Typed per-aspect settings in Den](https://gist.github.com/sini/c67ccc0d38983e6636ba408e042e36be)
how-to. This repo extends that recipe with the `userSettings`/`hostSettings`
reserved keys (the gist uses a single `settings` key on host) and an extra
inclusion-pruning layer (`pruneTree` / `includedSet`) so only included aspects
surface settings and inclusion of namespace aspects.

<!-- toc -->

- [What `userSettings` / `hostSettings` are](#what-usersettings--hostsettings-are)
  * [`hostSettings` vs `userSettings`](#hostsettings-vs-usersettings)
- [How den builds the namespace](#how-den-builds-the-namespace)
- [Namespace aspects (`den.ful`)](#namespace-aspects-denful)
- [Reading settings (decoupled from declaration)](#reading-settings-decoupled-from-declaration)
- [Settings vs. quirks](#settings-vs-quirks)

<!-- tocstop -->

## What `userSettings` / `hostSettings` are

`userSettings` (and `hostSettings` on host-scope aspects) is one of den's
**reserved keys** (`den.reservedKeys`). An aspect sets it to **advertise a
subtree of typed options** into the auto-generated `settings` namespace. It is
purely a _declaration_ — it has no behavior on its own.

- A block is a plain attrset of `mkOption`s, or a function
  `{user, ...}` / `{host, ...}` returning one (the function form lets a default
  reference `user.userName` / `user.repoRoot` without the module-system circular
  dependency of `_module.args.user`).
- The schema walks the aspect tree and builds `user.settings.<aspectPath>.<option>`
  (and `host.settings.<aspectPath>.<option>`) **mirroring the attrpath of the
  declaring aspect**. Where in the tree the block lives determines its option
  path — not which lambda reads it.

`userSettings` is effectively a **typed, tree-addressable config bus**: any
aspect can read any `user.settings.<path>`, not just the one that declared it.

### `hostSettings` vs `userSettings`

The only difference between `hostSettings` and `userSettings` is **scope, not
mechanism**:

- `hostSettings` are declared by aspects that configure **NixOS** (the host) and
  surface under `host.settings`.
- `userSettings` are declared by aspects that configure **Home Manager** (the
  user) and surface under `user.settings`.

Both are plain attrsets of `mkOption`s (or a function returning one) and both are
folded into the entity's auto-generated `settings` tree at the aspect's attrpath.
The settings generator treats them identically — pick `hostSettings` when the
option feeds NixOS-level config and `userSettings` when it feeds Home
Manager-level config.

## How den builds the namespace

Implemented in `modules/den/schema/{user,host}/settings.nix`. The flow:

1. `hasSettingsDeep` detects any node (or descendant) that has `userSettings`.
2. `nodeModule` builds a submodule per node containing:
   - the node's own `userSettings` options, and
   - a submodule child for **every descendant** that itself has settings.
     This mirrors the aspect tree 1:1.
3. `fullAspectTree` is the universe of possible settings (aspects + `den.ful`
   namespace aspects).
4. `pruneTree` + `includedSet` keep only branches of aspects the entity
   **actually includes**. A user's `includedSet` is the union of its own resolved
   aspects _and the host's_ — which is why a user can see settings for aspects the
   host delivers into its scope.
5. The result is a single `mkOption` `settings` whose type is the generated
   submodule. Options only exist for included aspects; removing an aspect from
   `includes` drops its settings from the type automatically.

Because pruning is by _inclusion_, not by _who reads it_, an aspect can declare
settings that some **other** aspect consumes.

## Namespace aspects (`den.ful`)

Den aspects that ship many direct aspects or sub-aspects (zen-browser, niri, noctalia,
nixvim, dms, noctalia-shell) are registered under `den.ful.<name>`. The
settings generator folds `den.ful` into `fullAspectTree`
(`modules/den/schema/{user,host}/settings.nix:91`), so a namespace aspect's
`userSettings`/`hostSettings` are discovered and pruned into the generated
`settings` tree exactly like local aspects. Including a whole namespace is done
through its `.full` aggregator (e.g. `zen-browser.full`, `niri.full`), with
`._` exposing its direct sub-aspects.

See den's [Namespaces guide](https://den.denful.dev/guides/namespaces) and
`AGENTS.md` "Namespaces" for the full picture.

```nix
# modules/den/aspects/dev/shell-tools/git.nix (simplified)
{lib, ...}: {
  den.aspects.dev.shell-tools.git = let
    inherit (lib) mkOption types;
  in {
    userSettings = {
      username = mkOption {
        type = types.str;
        default = "";
        example = "git";
        description = "Username to use for git.";
      };
      email = mkOption {
        type = types.str;
        default = "";
        example = "git@git.com";
        description = "Email to use for git.";
      };
    };
  };
}
```

Function form (when a default needs the entity context):

```nix
# modules/den/aspects/security/sops-user.nix (simplified)
userSettings = {user, ...}: {
  secretsDir = mkOption {
    type = types.path;
    # default references the entity, not available via _module.args
    default = ../../../../assets/users/${user.userName}/secrets;
    description = "Directory of this user's encrypted secret files.";
  };
};
```

## Reading settings (decoupled from declaration)

A declaring aspect **does not have to** read its own settings, and certainly does
not have to do so inside an `hm` or `nixos` lambda. Reading is done by addressing
the attrpath from _any_ class lambda that has the entity in scope:

```nix
# A sibling aspect reads settings declared by `awww.script`
# modules/den/aspects/everyday/wallpaper-managers/awww/service-settings.nix
den.aspects.everyday.wallpaper-managers.awww.userSettings = {user, ...}: let
  cfg = user.settings.everyday.wallpaper-managers.awww;
in {
  service = mkOption {
    type = types.submodule {
      options = {
        label = mkOption {
          type = types.str;
          # default cross-references the sibling script aspect's settings
          default = cfg.script.label;
          description = "Name to use for the service.";
        };
        # ...
      };
    };
  };
};
```

And `awww.script`'s own `hm` lambda reads **both** its own `script` settings and
the sibling `service` settings:

```nix
hm = {user, ...}: let
  cfg = user.settings.everyday.wallpaper-managers.awww.script;
  inherit (user.settings.everyday.wallpaper-managers.awww) service;
in {
  systemd.user.services.${service.label} = { /* ... */ };
};
```

This publish/subscribe shape is the whole point: `userSettings` is a shared,
namespace-addressable option channel keyed by aspect attrpath.

## Settings vs. quirks

| Mechanism                       | Use when                                                                                                    | Shape                                                                                                                        |
| ------------------------------- | ----------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| `userSettings` / `hostSettings` | An aspect exposes a **typed, named option** (or attrset/submodule of them) that users configure per entity. | One declared option per setting; addressed as `settings.<path>.<name>`.                                                      |
| Quirks (`den.quirks.*`)         | **Many aspects each contribute a fragment** that a collector folds into one result.                         | A data channel (`persistUser`, `niriSettings`, `zenProfileSettings`, …) collected via `lib.foldl lib.recursiveUpdate` / concat. |

See also `AGENTS.md` for the scope-projection caveat (`hasAspect` vs. probing
`settings`) when reading settings from a descendant scope.
