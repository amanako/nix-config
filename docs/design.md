# Design

Outline some decisions and choices made during development for anyone willing to extend the project or make corrections.

<!-- toc -->

- [Project Overview](#project-overview)
  * [File Organization](#file-organization)
  * [Aspect Inclusion](#aspect-inclusion)
  * [Quirks as Top Priority](#quirks-as-top-priority)
  * [Settings namespace](#settings-namespace)
  * [Documentation](#documentation)
  * [Leveraging Den Capabilities](#leveraging-den-capabilities)
  * [Specific Practices](#specific-practices)
- [Goals](#goals)

<!-- tocstop -->

## Project Overview

- **Framework:** [denful/den][den] — built with **[SoC]** in mind

### File Organization

- **Manageable size:**
  - Aim for files of consistent size - not small and scattered, not too large to get lost in complicated code
  - Exceptions are files made for a single purpose which don't gain that much by being divided or conjoined
  - Split into composable parts when a file gets out of control or mentally heavy

### Aspect Inclusion

- **Primary focus:** Including aspects should mean opt-in, not including / excluding should mean opt-out
- **Fine‑grained control:** Optional manual overrides / special cases handled with host and user schema options
  Ideally existing aspects should not be touched, only new ones made to override/build upon them.

### Quirks as Top Priority

Since general flow of building config relates to data, one might think that custom classes can prove to be amazing with guards logic and so on.
However upon some discussion I came to realize quirks overpower them with simplicity and versatility and should be considered first and foremost
in situations where multiple aspects contribute to some result(which is usually assembled by some collector aspect).

Conversation leading to this conclusion can be found [here](https://github.com/denful/den/discussions/590).

### Settings namespace

Aspects expose typed, per-entity options through `userSettings` / `hostSettings`
(reserved keys). den auto-generates a `settings` submodule mirroring the aspect
tree, pruned to what the entity includes. Declaration is decoupled from
consumption: an aspect may declare settings that a _different_ aspect reads by
attrpath. This is distinct from quirks, which fold fragments from many aspects
into one result. The generator is adapted from sini's
[Typed per-aspect settings in Den](https://gist.github.com/sini/c67ccc0d38983e6636ba408e042e36be)
how-to; see [settings.md](settings.md).

### Documentation

- Includes **tips & tricks** gathered from real‑world & personal usage
- Intended to help fellow Nix users starting with the framework (myself included), with room for future improvements

### Leveraging Den Capabilities

- Choosing the **best tool** for each task after thoughtful consideration

### Specific Practices

- Declare **[flake-file]** inputs, **[custom classes][custom-classes]**, lambda parameters etc., **as close to the point of use** as possible
- Prefer using [pipe-operators] for clearer intentions and similarities with other functional languages
- This makes removal or refactoring straightforward
- Declare [shorthand for homeManager class to use instead](modules/den/policies/hm-shorthand.nix)(Inspiration: https://github.com/sini/nix-config)

- Prefer using [inherit] over [with], expect in basic list expressions such as `with pkgs`.
  If there are multiple expressions you want to inherit assign one per row.
- Use [inherit] to either avoid repetition or shorten long names (such as `cfg` attribute used with aspect settings).
  Also if , as an example, you want to use `inherit (lib) mkOption` to avoid rewriting `lib` every time,
  you may as well inherit other `lib` attrset values you use, for the sake of consistency.
- When declaring options, follow this order, for each item where applicable (marked in parentheses) and prioritizing examples:
  1. type
  2. (default)
  3. (example)
  4. (description)
  5. (readOnly)
- Leave out default to signal the user an option should be set
- Write `description` as a proper sentence ending with a period (`.`). Use `''...''` for multi‑line text and `"..."` for a single line
- Make aspects themselves static(plain attrset) and configure lambda in shorter scope, for `nixos` or `hm` classes.<br>
  One exception to this "shorter scope" is `lib` which can be used in file scope if den needs it (that is module taking in lambda `{ lib, ...}` at file level).
  If this is the case, redeclartion of `{lib, ...}` within shorter scopes is redundant.

Other specifics can be figured out by looking at individual files (i.e. modules).

## Goals

- [TUI] experience
- Keyboard-driven
- Single theme spread across whole configuration: currently [gruvbox] but this may change
- **Light gaming** , I use it primarily for [VNs][vn]

[custom-classes]: https://den.denful.dev/guides/custom-classes
[den]: https://den.denful.dev
[flake-file]: https://github.com/denful/flake-file
[gruvbox]: https://duckduckgo.com/?q=gruvbox&iar=images&t=ffab
[inherit]: https://nix.dev/tutorials/nix-language.html#inherit
[pipe-operators]: https://nix.dev/manual/nix/latest/development/experimental-features.html?highlight=pipe#pipe-operators
[soc]: https://en.wikipedia.org/wiki/Separation_of_concerns
[tui]: https://en.wikipedia.org/wiki/Text-based_user_interface
[vn]: https://en.wikipedia.org/wiki/Visual_novel
[with]: https://nix.dev/tutorials/nix-language.html#with
