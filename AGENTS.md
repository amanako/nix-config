# AGENTS.md

<!-- toc -->

- [Mental model: the den architecture](#mental-model-the-den-architecture)
- [The `settings` namespace (the core gotcha)](#the-settings-namespace-the-core-gotcha)
- [Quirks: cross-aspect data collection](#quirks-cross-aspect-data-collection)
- [Classes and the `hm` shorthand](#classes-and-the-hm-shorthand)
- [Cross-scope membership checks (`hasAspect` is projected)](#cross-scope-membership-checks-hasaspect-is-projected)
- [Namespaces](#namespaces)
- [`provides.to-users`](#providesto-users)
- [`flake.nix` is generated — do not edit it by hand](#flakenix-is-generated--do-not-edit-it-by-hand)
- [Commands](#commands)
  * [Validation (mirrors CI)](#validation-mirrors-ci)
- [Formatting and pre-commit](#formatting-and-pre-commit)
  * [Do not manually run the formatter](#do-not-manually-run-the-formatter)
- [Style conventions (from `docs/design.md`)](#style-conventions-from-docsdesignmd)
- [Adding things](#adding-things)
- [Important gotchas](#important-gotchas)
- [Useful references](#useful-references)

<!-- tocstop -->

Guidance for AI agents working in this repository. This is a NixOS system
configuration built on the [den](https://den.denful.dev) framework, composed
with `flake-parts`, `import-tree`, and `flake-file`. Most non-obvious behavior
comes from how den wires things together, so read this before editing.

## Mental model: the den architecture

The repo is **not** a flat collection of NixOS modules. It is a den "system" with
three kinds of modules under `modules/`:

- **Aspects** (`modules/den/aspects/**` and `modules/{hosts,users}/*/aspect/**`)
  are reusable, composable units of configuration. An aspect is any module that
  sets `den.aspects.<path> = { ... }`. Aspects declare what they _include_, what
  they _configure_ (per class), and what _settings/quirks_ they expose.
- **Entries** (`modules/{hosts,users}/*/entry/**`) instantiate concrete hosts and
  users and compose aspects via attribute paths:
  - Host: `den.hosts.<architecture>.<hostname> = { ... }`
  - User: `den.hosts.<architecture>.<hostname>.users.<username> = { ... }`
- **Schema** (`modules/den/schema/**`) defines the den batteries and, most
  importantly, **auto-generates the `settings` namespace** for each entity from
  the aspect tree (see below). Host schema lives in `modules/den/schema/host`,
  user schema in `modules/den/schema/user`.

Everything under `modules/` is loaded **recursively by `import-tree`** (see
`flake.nix` output: `inputs.import-tree ./modules`). `import-tree` imports every
`.nix` file unless its name/folder is prefixed with `_`. It only sees files that
are **tracked by git**, so `git add` new files or they will be silently ignored.

> Rule of thumb: add new configuration by creating an **aspect** under
> `modules/den/aspects/...` (or extend an existing host/user aspect under
> `modules/{hosts,users}`), then pull it in via `includes` from an entry or
> parent aspect. Do not hand-write one giant module.

## The `settings` namespace (the core gotcha)

Hosts and users expose a single typed `settings` option whose sub-options are
**generated automatically** from the aspects they include. An aspect declares its
own settings under `hostSettings` (host-relevant) or `userSettings` (user-relevant),
each a plain attrset of `mkOption`s (or a function `{host, ...}` / `{user, ...}`
that returns one). `modules/den/schema/{host,user}/settings.nix` walks the aspect
tree and builds the matching submodule. The generator there is adapted from
sini's
[Typed per-aspect settings in Den](https://gist.github.com/sini/c67ccc0d38983e6636ba408e042e36be)
how-to (which covers a single `settings` key on host); this repo generalizes it
to the `userSettings`/`hostSettings` reserved keys plus an inclusion-pruning
layer.

Consequences that are easy to get wrong:

- A setting attrpath mirrors the aspect attrpath. In entries you write e.g.
  `settings.dev.shell-tools.git.username` for `den.aspects.dev.shell-tools.git` (see
  `modules/users/lunar-scar/entry/lunar-scar.nix`), or
  `settings.core.impermanence.persistenceDir` for
  `den.aspects.core.impermanence` (see
  `modules/hosts/nebula/entry/nebula.nix`).
- Settings are **pruned**: only aspects the entity (and its host) actually
  includes produce settings. If you add an aspect to `includes`, its settings
  appear; remove it and they vanish from the type.
- **Declaration is decoupled from consumption.** An aspect that sets
  `userSettings`/`hostSettings` does **not** have to read it back, and does not
  have to do so inside an `hm`/`nixos` lambda. Any aspect can read any
  `settings.<aspectPath>.<option>` by attrpath — `userSettings` is effectively a
  typed, tree-addressable config bus. Example: `awww.script` declares settings
  while the sibling `awww.service-settings` reads them (and cross-references them
  as defaults); `script`'s own `hm` reads both. See `docs/settings.md`.
- Aspects commonly read their _own_ settings inside their class lambda via the
  entity arg, e.g. `cfg = host.settings.core.impermanence;` (see
  `modules/den/aspects/core/impermanence/impermanence.nix`), or
  `cfg = user.settings.dev.shell-tools.git;` (see `modules/den/aspects/dev/shell-tools/git.nix`).
- `hostSettings` / `userSettings` are **reserved key names** (`den.reservedKeys`);
  do not reuse them for other purposes.

## Quirks: cross-aspect data collection

When several aspects contribute pieces to one result, den uses **quirks** instead
of custom classes. A quirk is a declared data channel (e.g. `niriSettings`,
`persistHost`, `persistUser`, `zenProfileSettings`). Individual aspects push data
into the quirk name (a top-level key on the aspect attrset), and a **collector**
aspect folds all contributions together and applies them.

Key examples:

- `den.quirks.persistUser` / `den.quirks.persistHost` gather directories/files
  to persist under impermanence. Aspects set `persistUser.directories = [...]`;
  `modules/den/aspects/core/impermanence/persist-user-collector.nix` concatenates
  and de-duplicates everything and writes `home.persistence.<dir>`.
- `den.quirks.niriSettings` gathers `programs.niri.settings` fragments; aspects
  set `niriSettings.<attr> = ...` (see
  `modules/den/aspects/everyday/browsers/zen-browser/zen-browser.nix`).
- `zen-browser.profileSettingsCollector` folds a list of setting aspects (some of
  which are functions receiving `{pkgs, lib, inputs', zenSearchEngines}`) via
  `lib.foldl lib.recursiveUpdate {}` (`modules/den/aspects/everyday/browsers/zen-browser/profile-settings-collector.nix`).

Prefer quirks over guard-logic custom classes whenever multiple aspects feed one
output. See `docs/design.md` "Quirks as Top Priority".

## Classes and the `hm` shorthand

Aspect lambdas are keyed by den **class**: `nixos = {pkgs, ...}: {...}` configures
NixOS, `hm = {pkgs, ...}: {...}` (or `{user, ...}`) configures Home Manager. The
repository deliberately uses Home Manager **as a NixOS module**, not standalone
(see `docs/tips.md`).

`hm` is a shorthand: `modules/den/classes/hm.nix` declares `den.classes.hm`, and
`modules/den/policies/hm-shorthand.nix` routes it into the real `homeManager`
class via `den.lib.policy.route`. Write `hm = ...` in aspects; it becomes
`homeManager`. User schema default classes are `["homeManager"]`
(`modules/den/schema/user/default.nix`).

## Cross-scope membership checks (`hasAspect` is projected)

`host.hasAspect` / `user.hasAspect` are **scope-projected**: inside a class
lambda that runs at a _descendant_ scope (e.g. an `hm` lambda for a user aspect,
or any lambda bound to a child entity), `host.hasAspect X` answers "is `X`
delivered INTO this active scope (i.e. provided to this user)?", NOT "does the
host include `X`?". Concretely, `den.aspects.core.impermanence` is included at
host level but only `provides.to-users` its `persist-user-collector` (not the
aspect itself), so `host.hasAspect den.aspects.core.impermanence` returns
`false` from a user-scope `hm` even though the host clearly has it. This is a
classic source of "works at host scope, blank at user scope" bugs.

For reliable, scope-invariant membership checks prefer one of:

- `lib.hasAttrByPath ["<aspect>" "..."] host.settings` (or `user.settings`).
  The `settings` namespace reflects the actually-generated settings and is safe
  to probe (returns `false` when the path is absent), unlike `host.hasAspect`.
- Reading the **concrete effect** the aspect produces, e.g.
  `config.home.persistence` for impermanence — also scope-invariant and needs no
  membership query at all.

## Namespaces

Larger flake projects that provide many aspects (zen-browser, niri, noctalia,
nixvim) are brought in as den **namespaces** via `inputs.den.namespace "name" false`
(e.g. `modules/den/aspects/everyday/browsers/zen-browser/zen-browser.nix`).
Namespaces expose a `.full` aggregator (`zen-browser.full`, `niri.full`,
`noctalia.full`) and `._` (all direct subaspects). Include these via
`includes` rather than listing every sub-aspect. Namespace aspects are also
supported by the settings generator: their `userSettings`/`hostSettings` are
folded in from `den.ful` and pruned into the entity's `settings` tree like local
aspects (see `docs/settings.md` "Namespace aspects").

## `provides.to-users`

A host aspect can inject aspects into its users using
`provides.to-users.includes = [ ... ]`. Example:
`den.aspects.core.impermanence` exposes
`den.aspects.core.impermanence.persist-user-collector` to its users
(`modules/den/aspects/core/impermanence/impermanence.nix`). Use this for
host-driven, user-wide config rather than duplicating includes per user.

## `flake.nix` is generated — do not edit it by hand

`flake.nix` is auto-generated by the `flake-file` app. To add or change a flake
input, declare it inside a module via `flake-file.inputs.<name>.url = "..."`
(and any `flake-file.nixConfig` substituters/keys). Then regenerate:

```
just fw        # alias for: nix --accept-flake-config run .#write-flake
```

`flake.nix` top comment states the same. Only edit `flake.nix` manually to fix a
typo in an input URL, after which you should re-run `just fw`. `flake.lock` is
updated by `just fupdate` and committed by CI (see below).

## Commands

`just` is the primary entry point. Recipes (`just --list`):

| Recipe                         | Alias | Purpose                                               |
| ------------------------------ | ----- | ----------------------------------------------------- |
| `rebuild-switch host=hostname` | `rs`  | `nh os switch` (activate now, set default boot)       |
| `rebuild-boot host=hostname`   | `rb`  | `nh os boot` (activate after reboot)                  |
| `disko host=hostname`          | `d`   | Run disko partitioning for host                       |
| `vm host=hostname`             |       | Build/run host VM                                     |
| `repl`                         | `r`   | `nix repl` on this flake                              |
| `fwrite`                       | `fw`  | Regenerate `flake.nix` from `flake-file` inputs       |
| `fupdate *inputs`              | `fu`  | `fwrite` + `nix flake update` + `fwrite`              |
| `pull-flake branch="main"`     | `pf`  | Restore `flake.nix`/`flake.lock` from a remote branch |

`hostname` defaults to the current host (`uname -n`).
All `nix`/`nh` invocations pass `--accept-flake-config` because `flake.nix`
embeds `nixConfig` (experimental features, substituters, trusted keys).

Development shell: `nix-direnv` is enabled via `.envrc`
(`use_flake . --accept-flake-config`). Run `direnv allow .` to auto-load the dev
shell, or `nix develop` otherwise.

### Validation (mirrors CI)

The Woodpecker `check.yml` does exactly this — run it locally before pushing:

```
just fwrite
nix --accept-flake-config flake check -L
```

The GitHub Action builds `.#hosts` (every host's toplevel for the runner's
architecture) on x86 and ARM64 runners and pushes the results to the `amanako`
cachix cache (`modules/packages/hosts.nix`).

## Formatting and pre-commit

`.pre-commit-config.yaml` enforces, via `pre-commit run` (or on commit):

- **alejandra** formats all `.nix` files (this is the canonical formatter —
  follow its output; do not run `nixpkgsfmt`).
- **stylua** formats `.lua` (Neovim/nixvim config under
  `modules/den/aspects/dev/editors/**/lua`).
- **prettier** formats `.yml`/`.yaml`.
- **markdown-toc** rewrites `

`blocks in`\*.md` (README and docs).

- `woodpecker-cli lint` validates `.woodpecker/*.yml`.

Keep markdown TOC blocks intact so the hook can update them.

### Do not manually run the formatter

Do **not** invoke `alejandra`/`stylua`/`prettier` yourself (e.g. `nix run
nixpkgs#alejandra -- file.nix`). Formatting is enforced automatically by the
pre-commit hook on every commit, and CI re-runs it. Manually formatting risks
producing output that diverges from the hook's pinned tool versions, or leaving
partial commits that then fail CI. Just write code in a reasonable style; the
hook fixes the rest. If you want to verify formatting before committing, run
`pre-commit run --all-files` rather than calling a formatter directly.

## Style conventions (from `docs/design.md`)

These are enforced by code review and matter for consistency:

- **Option declaration order** for each `mkOption` (where applicable):
  `type`, then `default`, `example`, `description`, `(readOnly)`. Omit `default`
  to signal the user must set the option.
- **Descriptions** are proper sentences ending with a period. Use `''...''` for
  multi-line, `"..."` for single line.
- **Prefer `inherit` over `with`**, except in simple list expressions like
  `with pkgs; [ ... ]`. One `inherit` per row. Use `inherit (lib) mkOption types;`
  to avoid repeating `lib`.
- **Pipe operators** (`|>`, `<|`) are used extensively (an experimental Nix
  feature enabled repo-wide). Use them for data flow instead of nested `let`.
- Declare flake-file inputs, custom class definitions, and lambda parameters
  **as close to the point of use** as possible; this keeps removal/refactor local.
- Keep aspects **static** (plain attrsets) and configure via the shorter-scope
  class lambda (`nixos`/`hm`). `lib` may be used at file scope only if the module
  takes `{lib, ...}` at file level; otherwise redeclare it in the inner lambda.
- Aim for **consistent, moderate file sizes**; split a file when it becomes
  mentally heavy.

## Adding things

**New flake input:** add `flake-file.inputs.<name>.url` (+ `nixConfig`
substituters/keys if needed) in the module that uses it, then `just fw`.

**New aspect:** create `modules/den/aspects/<group>/<name>.nix` (or a subfolder
with `default.nix`) setting `den.aspects.<group>.<name> = { includes, nixos?, hm?,
hostSettings?/userSettings?, quirks..., description? }`. Then add it to the
relevant `includes` (a host/user aspect or parent aspect).

**New host:** add `modules/hosts/<host>/entry/<host>.nix` with
`den.hosts.x86_64-linux.<host> = { settings = { ... }; }` and (optionally)
`modules/hosts/<host>/aspect/<host>.nix` for its aspect includes. Set
`settings.repoRoot` (or rely on the user's `repoRoot`).

**New user:** add `modules/users/<user>/entry/<user>.nix` with
`den.hosts.x86_64-linux.<host>.users.<user> = { isPrimaryUser, repoRoot,
preferences, settings = {...} }`; optionally an `aspect/<user>.nix`. `repoRoot`
defaults to `host.repoRoot` and is read-only unless `isPrimaryUser = true`.

Subaspects are reachable by appending `.`, e.g.
`den.aspects.lunar-scar._` includes all of that user's direct subaspects
(`modules/users/lunar-scar/aspect/lunar-scar.nix`).

## Important gotchas

- **Files must be `git add`ed.** `import-tree` ignores untracked files, so a new
  `.nix` module that isn't staged will not be loaded, producing confusing
  "option not found" or silently missing config.
- **Reference executables via `pkgs`, never as bare strings.** Writing a
  hardcoded binary name like `on-click = "waybar"` fails because the name is
  not on `PATH` at evaluation/activation time (it resolves to nothing, so the
  command silently does nothing). Prefer `lib.getExe pkgs.<pkg>` for the
  package's main binary and `lib.getExe' pkgs.<pkg> "<bin>"` for a non-main
  binary; fall back to `${pkgs.<pkg>}/bin/<name>` only when building a longer
  command string. Avoid putting a package in `home.packages` just so a bare
  binary name resolves — interpolate the derivation instead so it's tracked in
  the closure and always available. See
  `modules/den/aspects/everyday/bars/waybar/waybar.nix` (`wttrbar`, `brightnessctl`,
  `btop`, `libnotify`, `bluetui`, `wifitui` all referenced via
  `lib.getExe`/`lib.getExe'`).
- **Always pass `--accept-flake-config`** (or rely on the dev shell). The
  embedded `nixConfig` enables pipe-operators and trusted binary caches
  (`amanako.cachix.org`, `nix-community`, `noctalia`, `niri`, `chaotic`, ...).
  Without it, evaluation fails or re-downloads everything.
- **Pipe operators and curried `lib` functions don't mix.** `x |> lib.mapAttrs'
  f` parses as `(lib.mapAttrs' f) x` *only* when `f` is fully applied; writing
  `x |> (attrs: lib.mapAttrs' f attrs)` leaves a **partially-applied function**
  as the pipeline result and fails with `expected a set but found a function`
  (seen at `modules/users/lunar-scar/aspect/secrets.nix`). When a `lib` higher-
  order function needs both a fn and the attrset, pipe into a lambda that fully
  applies it and returns the *result*, e.g.
  `secretEnv |> lib.mapAttrsToList (k: v: ...) |> builtins.listToAttrs`, or
  simply build the attrset in a `let` instead of forcing it through `|>`.
- **`flake.nix`/`flake.lock` are committed and CI-gated.** CI regenerates
  `flake.nix` via `write-flake` and runs `nix flake check -L` on `main`/`dev`.
  Weekly Woodpecker cron bumps `flake.lock` into a `weekly-flake-update` branch and
  opens a PR to `dev`. Don't hand-edit `flake.lock` except via `just fupdate`.
- **`repoRoot` is mandatory** for any host/user using paths/data from the repo;
  assertions fail if neither host nor user sets it.
- **nixpkgs tracks `nixos-unstable`.** Expect frequent upstream churn; flake
  bumps land on `dev` first.
- This config targets impermanence (tmpfs root) with persistent dirs collected
  via the `persistHost`/`persistUser` quirks. To keep a file/dir across reboots,
  add it to the relevant quirk (see `docs/usage.md`), not by editing the module
  system directly.
- **Inclusion is the opt-in mechanism; do not add `enable` toggles.** Per
  `docs/design.md`, including an aspect means opt-in and not-including means
  opt-out. Configure variation through `hostSettings`/`userSettings`, never a
  boolean `enable` guard (see `modules/den/aspects/security/sops-user.nix` for the
  pattern).
- **Quirk data is always a *list* of per-aspect contributions**
  Den's pipe assembly passes quirk data to collectors as a flat list
  where each element is what a single aspect emitted. Accessing like
  `quirkData.someKey or []` silently yields `[]` because a list has no named
  attributes. Always iterate with `lib.concatMap (entry: entry.someKey or [])`
  — the same pattern used by every existing collector (`persist-user-collector`,
  `niri-settings-collector`, `conflicts-collector`). See
  `modules/den/aspects/basic/conflicts-collector.nix` for a corrected example.
- Primary development branch is **`dev`**; `main` is "stable". README's `old`
  branch holds the pre-den config for reference only.

## Useful references

- `docs/` — `design.md` (decisions/conventions), `development.md` (dev workflow),
  `usage.md` (install/build), `tips.md` (practical notes), `included.md`.
- `README.md` — structure overview, branches, binary cache.
- Upstream: den framework <https://den.denful.dev> and its discussions/issues for
  framework-specific questions; use `nix repl` / den's debug guide when an aspect
  resolves unexpectedly.
- Feature-specific quirks/usage are often documented inline in the aspect folder
  (e.g. `modules/den/aspects/core/boot/limine/secure-boot-setup.md`).
