# NixOS configuration

<a href="https://nixos.org"><img alt="NixOS" src="https://img.shields.io/badge/NixOS-5277C3?style=for-the-badge&logo=nixos&logoColor=%23a89984&labelColor=%2332302f&color=%23a9b665" /></a>
<a href="https://den.denful.dev"> <img alt="Dendritic Nix" src="https://img.shields.io/badge/Dendritic-Nix-Informational?style=for-the-badge&logo=nixos&logoColor=%23458588&labelColor=%2332302f&color=%23d3869b" /></a>

![build-and-push](https://img.shields.io/github/actions/workflow/status/amanako/nix-config/build-and-push-to-cache.yml?style=plastic&logo=ebox&logoColor=d4be98&label=build)
![checks](https://ci.codeberg.org/api/badges/16923/status.svg)

## Credits
Because of diligent work of these people/communities configuration was able to rise to these heights. This couldn't be done without them. Thank you.

- https://nixos-and-flakes.thiscute.world (the cornerstone of my journey)
- https://den.denful.dev/tutorials/default (base)
- https://den.denful.dev (framework which helped me grasp and maximize config potential)
- and redditors over at [r/NixOS](https://www.reddit.com/r/NixOS) for ideas and answers to my questions

## Table of contents (a.k.a. TOC)

<!-- toc -->

- [Branches](#branches)
- [Docs](#docs)
- [Screenshots](#screenshots)
- [Binary cache](#binary-cache)
- [Licence and word of warning](#licence-and-word-of-warning)

<!-- tocstop -->

## Branches

General branches are listed below:

| Branch              | Description |
|---------------------|-------------|
| dev                 | Branch primarily targeted by CI and commits. All the new changes/plans land here first. After enough testing (currently by me solely) main is fast-forwarded to match certain commit or `HEAD` of this branch. |
| main                | "Stable" branch. Stuff residing here shouldn't be error-prone and is least likely to exhibit unexplainable behaviour. No guarantees though. If anything is breaking fix will be shipped as soon as possible. |
| old                 | Old pre-den config. This branch is just here to showcase and remind of how mature APIs beats regular nix in terms of readability and potential.                                                              |
| weekly-flake-update | Temporary branch made by Woodpecker CI [here](.woodpecker/bump-flake.yml) containing latest flake files to merge into dev branch. Seeing this branch likely means PR isn't merged yet. Deleted after merge.  |

Other than these, temporary branches may be added but their purpose should be understandable judging by name.

## Docs

All relevant cross-cutting guides/information regarding usage, design, development etc. is documented in [docs](docs), in case of any questions refer to those.
Otherwise, feature-specific stuff are documented in directory where that feature resides.

## Screenshots

These can be found in [screenshots folder](assets/screenshots).

As for credits: <br>
Fastfetch logo is from: https://gitlab.com/ntgn/ascii-art( [LICENCE](https://gitlab.com/ntgn/ascii-art/-/blob/main/LICENSE) ).<br>
Wallpapers can be found at: https://codeberg.org/voidptrx/wallpapers.<br>

## Binary cache

Build artifacts are cached and stored via [cachix] at [cache].<br>
Public key is available there:

```
amanako.cachix.org-1:sYWzosQAXLkVVLsWjl/36EJy5UqYHyvs5ztnKX2mmmY=
```

Relevant workflow file can be found [here](.github/workflows/build-and-push-to-cache.yml).
To avoid duplication and reduce cache size, store paths already present at upstream caches are avoided.

## Licence and word of warning

Repository is licenced under [MIT](LICENSE).<br>
Even though it's just a collection of config files, this is done to evade problem emerging from use of repository and protect rights.<br>
In general, to avoid unpleasant situations(deletion of partitions, emergency modes, kernel panics... all situations I've been through) you are highly advised to actually read through the code
and understand it's purpose. For the most part attempts are made to document all the small quirks and difficulties either via comments in .nix files, [docs](docs) or via inline markdown files, i.e. bundled in folder containing aspect in question.
Having a backup of important data is absolutely recommended.<br>
Den seems to be a niche spot in already niche Nix environment, so most of the time following their [github repo][den repo] updates and conversations will aid you best.<br>
Assets from third-party repositories(primarily flake-inputs, den included) are licenced under their respective licences.

[cache]: https://app.cachix.org/cache/amanako
[cachix]: https://www.cachix.org
[den repo]: https://github.com/denful/den
