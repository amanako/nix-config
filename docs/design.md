# Design

Outline some decisions and choices made during development for anyone willing to extend the project or make corrections.

<!-- toc -->

- [Project Overview](#project-overview)
  * [File Organization](#file-organization)
  * [Aspect Inclusion](#aspect-inclusion)
  * [Documentation](#documentation)
  * [Leveraging Den Capabilities](#leveraging-den-capabilities)
  * [Specific Practices](#specific-practices)
- [Goals](#goals)

<!-- tocstop -->

<!-- tocend -->

## Project Overview

- **Framework:** [denful/den][den] — built with **[SoC]** in mind.

### File Organization

- **Manageable size:**
  - Aim for _~80_ lines per file.
  - Split into composable parts when a file gets out of control or mentally heavy.

### Aspect Inclusion

- **Primary focus:** Including aspects should mean opt-in, not including / excluding should mean opt-out.
- **Fine‑grained control:** Optional manual overrides / special cases handled with host and user schema options.
Ideally existing aspects should not be touched, only new ones made to override/build upon them.

### Documentation

- Includes **tips & tricks** gathered from real‑world & personal usage.
- Intended to help fellow Nix users starting with the framework (myself included), with room for future improvements.

### Leveraging Den Capabilities

- Choosing the **best tool** for each task after thoughtful consideration.

### Specific Practices

- Declare **[flake-file]** inputs, **[custom classes][custom-classes]**, lambda parameters etc., **as close to the point of use** as possible.
- Prefer using [pipe-operators] for clearer intentions and similarities with other functional languages
- This makes removal or refactoring straightforward.
- Declare [shorthand for homeManager class to use instead](modules/den/policies/hm-shorthand.nix)(inspiration: https://github.com/sini/nix-config)

Other specifics can be figured out by looking at individual files (i.e. modules).

## Goals

- [TUI] experience
- Keyboard-driven
- Single theme spread across whole configuration: currently [gruvbox] but this may change
- **Light gaming** , I use it primarily for [VNs][vn]

[gruvbox]: https://duckduckgo.com/?q=gruvbox&iar=images&t=ffab
[pipe-operators]: https://nix.dev/manual/nix/latest/development/experimental-features.html?highlight=pipe#pipe-operators
[vn]: https://en.wikipedia.org/wiki/Visual_novel
[tui]: https://en.wikipedia.org/wiki/Text-based_user_interface
[soc]: https://en.wikipedia.org/wiki/Separation_of_concerns
[flake-file]: https://github.com/denful/flake-file
[custom-classes]: https://den.denful.dev/guides/custom-classes
[den]: https://den.denful.dev
