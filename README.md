# NixOS configuration

<a href="https://nixos.org"><img alt="NixOS" src="https://img.shields.io/badge/NixOS-5277C3?style=for-the-badge&logo=nixos&logoColor=%23a89984&labelColor=%2332302f&color=%23a9b665" /></a>
<a href="https://den.denful.dev"> <img alt="Dendritic Nix" src="https://img.shields.io/badge/Dendritic-Nix-Informational?style=for-the-badge&logo=nixos&logoColor=%23458588&labelColor=%2332302f&color=%23d3869b" /></a>

![build-and-push](https://img.shields.io/github/actions/workflow/status/amanako/nix-config/build-and-push-to-cache.yml?style=plastic&logo=ebox&logoColor=d4be98&label=build)
![checks](https://ci.codeberg.org/api/badges/16923/status.svg)

## Credits

- https://nixos-and-flakes.thiscute.world (the cornerstone of my journey)
- https://den.denful.dev (framework which helped me grasp and maximize config potential)
- https://den.denful.dev/tutorials/default (base)
- https://github.com/AniviaFlome/nix-config ([fish] and [zen-browser])
- https://github.com/zerokqx/ZNix (some [nixvim] plugins)
- and redditors over at [r/NixOS](https://www.reddit.com/r/NixOS) for ideas and answers to my questions

## Table of contents

<!-- toc -->

- [Design](#design)
- [Goals](#goals)
- [Included](#included)
- [Screenshots](#screenshots)
  * [Noctalia](#noctalia)
  * [Dank Material Shell](#dank-material-shell)
- [Binary cache](#binary-cache)
- [Cloning repo](#cloning-repo)
- [Making a config](#making-a-config)
- [Build steps](#build-steps)
- [Secure boot setup](#secure-boot-setup)
- [Development](#development)
  * [Just commands](#just-commands)
  * [Pulling remote changes](#pulling-remote-changes)
- [Tips](#tips)
- [Licence and word of warning](#licence-and-word-of-warning)

<!-- tocstop -->

## Design

- [denful/den][den] framework with [SoC] in mind.
- Files not overwhelmingly long (ideally ~80 lines), splitting to composable parts if crossing the line or causing severe mental load
- Documented with tips and tricks I learned along the way to hopefully make it easier to understand for fellow nix users (likely pending improvements)
- Using most of den capabilities - thorough thinking of which tool is best for the job at hand
- Creating declarations, [flake-file] inputs, [custom classes] etc. near to actual place of usage to allow for easy removal<br>
Other specifics can be figured out by comparing individual files.

## Goals

- [TUI] experience
- Keyboard-driven
- Uniformness with **[gruvbox]** theme
- **Light gaming** , I use it primarily for [VNs][vn]

## Included

<div align="center">

| Functionality | Software |
|:----------------:|:---------------------------------------------------------------------:|
| Terminal | [kitty] |
| File Editor | [neovim](native and [nixvim]) |
| File Manager | [yazi] / [thunar] |
| Window Manager | [niri] |
| Quickshell | [noctalia], with [dms] as another option |
| Browser | [zen-browser] |
| Document Viewer | [zathura] |
| Input Method | [fcitx5] |
| Wallpaper Manager| [awww] |
| Shell | [fish] |
| Display Manager | [ly] |
| Boot Loader | [limine], for setup check [README](modules/aspects/boot/limine) |
| Memory layout | btrfs (unencrypted) via [disko] + [impermanence] |

and some secondary options.

</div>

## Screenshots

### Noctalia

![noctalia-preview](assets/screenshots/2026-03-14-noctalia-preview.png)

Logo is from https://gitlab.com/ntgn/ascii-art: [LICENCE](https://gitlab.com/ntgn/ascii-art/-/blob/main/LICENSE).

### Dank Material Shell

![dank-material-shell-preview](assets/screenshots/2026-03-29-dms-preview.png)

All screenshots can be found [here](assets/screenshots).<br>
Wallpapers can be found [here](https://codeberg.org/voidptrx/wallpapers).<br>

## Binary cache

Build artifacts are cached and stored via [cachix] at [cache].<br>
Public key is available there:

```
amanako.cachix.org-1:sYWzosQAXLkVVLsWjl/36EJy5UqYHyvs5ztnKX2mmmY=
```

Relevant workflow file can be found [here](.github/workflows/build-and-push-to-cache.yml).

It is using [omnix] to create a om.json file with all flake outputs,
which is then consumed by [cachix-push] tool and pushed to cache.
This way outputs are also pinned and easier to maintain.<br>
To avoid duplication and reduce cache size, store paths already present at upstream caches are avoided.

## Cloning repo

Clone and enter the repo with the following command:

```
# For enabled flakes and nix-command
nix run nixpkgs#git -- clone https://codeberg.org/abyssal-twilight/nix-config.git && cd nix-config

# For other users (after running installation flakes are used by default so this is temporary workaround)
nix-shell -p git --run "git clone https://codeberg.org/abyssal-twilight/nix-config.git" && cd nix-config
```

No matter the choice, option repoRoot should be set for either host or user,
where user preference may override hosts choice making both of them eligible.<br>
See [Making a config](#making-a-config).

## Making a config

> Since then uses [import-tree] as long as folders aren't prefixed with \_, they will be included by default.<br>
> That means it all boils down to individual preference. Therefore following will be my current preference which is subject to change.
> I accept corrections if I am mistaken somewhere or same can be achieved in an easier to understand fashion.

Users can be created by making an entry in [`users`](modules/users) directory, whereas host are made by adding an entry under [`hosts`](modules/hosts) folder.<br>
Following instruction apply equally to both of them, with difference which is explained below.

Duties are split among 2 folders: `entry` and `aspect`(optional), where:

- `entry` is made for den's definition and options which is tasked with actually creating host/user. Where applicable it should be prioritized over `aspect`.
- `aspect` is reserved for potential overrides for each of classes(including [custom][custom-classes] ones).<br>

Notable difference is that one user can be declared across multiple host and even have different den options per host.
This explains the structure of attribute set:

```
{
  den.hosts.${architecture}.${hostname}.users.${username} = {
    ...
  };
}
```

For such users I would suggest making multiple files within `entry` folder with this pattern for example: `${user}-${host}.nix`.<br>
Furthermore, all files can be broken into easy-to-follow pieces which is displayed in the examples.<br>
My current user and host are provided as a starting point. Please reference [`users`](modules/users) and [`hosts`](modules/hosts).

There are some necessary options like `user.repoRoot` taking `host.repoRoot` as fallback value, which is supposed to represent directory of cloned repo, and should be set upfront.
Other than that some other options which are a must likely have an assertion forcing repo users to make a declaration.

For hosts using disko configuration packages are exposed when using `disko.devices` host schema option with the following format: `${host}-disko`,
and can be easily run with:

```
# Run script to format disks of all declared devices on host
just disko
```

If this is not the case, manual partitioning is required, I can recommend taking a look at this [video].

When using impermanence: to persist configuration add directory containing configuration to persys class in host or user aspect, either with:

```
persysUser.directories = [
  # Example path - made at $HOME/nix-config
  "nix-config"
  # It can be some upper path for example:
  "Documents"
  # and then copied as a subfolder
];
```

or

```
persys.directories = [
  # Typical nixos configuration path
  "/etc/nixos"
;]
```

## Build steps

After completing previous section:

1. Run nixos-install and follow instructions:

```
nixos-install --flake $REPO_DIR
```

2. And then copy configuration over to desired (or persisted) folder.

```
cp -r $CONFIG_DIRECTORY $PATH_TO_FOLDER
```

3. Reboot

```
reboot
```

After completing setup running:

```
# Configuration activates after reboot
just rb
```

will build host using [nh].

## Secure boot setup

After rebuilding, extra steps are needed to enable secure boot.

For [limine]:

- Boot to firmware and clear keys via _restart to setup mode_ or similar.
- Run:

```
# Create keys in /var/lib/sbctl
sudo sbctl create-keys
# Enroll keys with --microsoft flag recommended
sudo sbctl enroll-keys --microsoft --firmware-builtin
# Sign limine boot entry to be able to boot to it
sudo sbctl sign /boot/efi/limine/BOOTX64.EFI
# Reboot
reboot
```

If anything fails try the following:

- Secure boot failures in BIOS: Apply previously mentioned setup mode in bios. Retry.
- Keys don't get recognized: Temporarily remove `wantsSecureBootSupport` host option, run `sbctl reset`, rebuild and remove `/var/lib/sbctl`(for non-ephemeral users). Reboot and retry.

## Development

[nix-direnv] is automatically enabled for all users.
To begin with development you are advised to use `direnv allow .` in repo root.
This enables automatic loading of environment and all packages each time you `cd` into directory,
all while caching results for great responsiveness.
If that doesn't fit you(possibility of running arbitrary dangerous commands)
simply run `nix develop` to enter shell with all dependencies.

### Just commands
All supported just commands can be displayed by running `just`.
This is the recommended way of interacting with repo since it's simple and focused.
Descriptions are provided.

```
  just
just --list
Available recipes:
    disko                    # Run disko configuration for current host [alias: d]
    fcheck                   # Check configuration of flake.nix from repo root [alias: fc]
    fupdate *inputs          # Update one or more flake inputs, all when no inputs specified [alias: fu]
    fwrite                   # Update flake inputs using "write-flake" app of flake-file [alias: fw]
    help                     # Display all recipes [alias: h]
    pull-flake branch="main" # Pull in changes from remote [alias: pf]
    rebuild-boot             # Rebuild config with nh and make it the default boot entry, activated after reboot [alias: rb]
    rebuild-switch           # Rebuild and activate config with nh and make it the default boot entry [alias: rs]
    repl                     # Enter nix repl with flake.nix from repo root [alias: r]
    vm                       # Spin up a virtual machine for current host
```

### Pulling remote changes

In case of remote updates, run `just pull-flake` to grab latest `flake.nix` and `flake.lock` files.
Works if no changes were made to local flake files. Otherwise manual intervention with `git rebase`
is required.

## Tips

Following are some of tips from personal experience(pending update and subject to change):

- If faced with choice, **prefer using [home manager as a NixOS module over standalone homes][hm]**.<br>
  Den allows declaring `den.homes` to achieve functionality for standalone home
  but I have deliberately omitted using it in configuration for convenience of rebuilding.

- Be sure to refer to [upstream documentation][docs] whenever met with difficulties.

- Use `nix-repl` when not sure why something doesn't work as intended. For den-specific stuff,
  reference [den's debug guide][den's debug quide].

## Licence and word of warning

Repository is licenced under [MIT](LICENCE).<br>
Even though it's just a bunch of config files, I mainly did this to evade law suits or similar and protect rights.<br>
In general, to avoid unpleasant situations(deletion of partitions, emergency modes, kernel panics... all situations I have been through) you are highly advised to actually read through the code
and understand it's purpose. For the most part I haven't documented it, but when I have some time to spare I will make advancements in that _aspect_.<br>
Having a backup of important data is absolutely recommended.<br>
Den seems to be a niche spot in already niche Nix environment, so most of the time following their [github repo][den repo] updates and conversations will aid you best.<br>
Assets from third-party repositories(primarily flake-inputs, den included) are licenced under their respective licences.

[awww]: https://codeberg.org/LGFae/awww
[cache]: https://app.cachix.org/cache/amanako
[cachix]: https://www.cachix.org
[cachix-push]: https://github.com/juspay/cachix-push
[custom-classes]: https://den.denful.dev/guides/custom-classes
[den]: https://den.denful.dev
[den repo]: https://github.com/denful/den
[den's debug guide]: https://den.denful.dev/guides/debug/
[disko]: https://github.com/nix-community/disko
[dms]: https://danklinux.com/
[docs]: https://den.denful.dev/overview
[flake-file]: https://github.com/denful/flake-file
[fcitx5]: https://fcitx-im.org/wiki/Fcitx_5
[fish]: https://fishshell.com
[gruvbox]: https://duckduckgo.com/?q=gruvbox&iar=images&t=ffab
[hm]: https://nix-community.github.io/home-manager/index.xhtml#ch-installation
[impermanence]: https://github.com/nix-community/impermanence
[import-tree]: https://github.com/denful/import-tree
[kitty]: https://sw.kovidgoyal.net/kitty
[limine]: https://github.com/Limine-Bootloader/Limine
[ly]: https://codeberg.org/fairyglade/ly
[neovim]: https://neovim.io
[nh]: https://github.com/nix-community/nh
[niri]: https://niri-wm.github.io/niri
[nixvim]: https://github.com/nix-community/nixvim
[noctalia]: https://noctalia.dev
[omnix]: https://github.com/juspay/omnix
[soc]: https://en.wikipedia.org/wiki/Separation_of_concerns
[thunar]: https://docs.xfce.org/xfce/thunar/start
[tui]: https://en.wikipedia.org/wiki/Text-based_user_interface
[video]: https://www.youtube.com/watch?v=lUB2rwDUm5A
[vn]: https://en.wikipedia.org/wiki/Visual_novel
[yazi]: https://yazi-rs.github.io
[zathura]: https://pwmt.org/projects/zathura
[zen-browser]: https://github.com/0xc000022070/zen-browser-flake
[nix-direnv]: https://github.com/nix-community/nix-direnv
