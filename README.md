<div align="center">
  <h1> :snowflake: NixOS configuration :snowflake: </h1>
</div>
  
  
<p align="center">
  <a href="https://nixos.org"><img alt="NixOS" src="https://img.shields.io/badge/NixOS-5277C3?logo=nixos&logoColor=fff" /></a>
  <a href="https://dendritic.oeiuwq.com"> <img alt="Dendritic Nix" src="https://img.shields.io/badge/Dendritic-Nix-informational?logo=nixos&logoColor=white"/> </a>
</p>

## Design
* [vic/den][den] framework with [SoC][SoC] in mind.
* Code is documented with tips I learned along the way.

## Goals
* [TUI][TUI] experience
* Keyboard-driven
* [Neovim][neovim] as an **all-encompassing text editor**
* Uniformness with **[gruvbox][gruvbox]** theme
* **Light gaming** , I use it primarily for [VNs][VN]

## Included

<div align="center">

  |  Functionality   |   Software                                                            |
  |:----------------:|:---------------------------------------------------------------------:|
  | Terminal         | [kitty][kitty]                                                        | 
  | File Editor      | [neovim][neovim](native)                                              |
  | File Manager     | [yazi][yazi] / [thunar][thunar]                                       |
  | Window Manager   | [niri][niri]                                                          |
  | Quickshell       | [noctalia][noctalia], with [dms][dms] as another option               |
  | Browser          | [zen-browser][zen-browser]                                            |
  | Document Viewer  | [zathura][zathura]                                                    |
  | Input Method     | [fcitx5][fcitx5]                                                      |
  | Wallpaper Manager| [awww][awww]                                                          |
  | Shell            | [fish][fish]                                                          |
  | Display Manager  | [ly][ly]                                                              |
  | Boot Loader      | [limine][limine], for setup check [README](./modules/aspects/hardware)|
  | Memory layout    | btrfs (unencrypted) via [disko][disko] + [impermanence][impermanence] |

and some secondary options.

</div>

## Screenshots

<h2>
  Noctalia preview
</h2>

![noctalia-preview](./assets/screenshots/2026-03-14-noctalia-preview.png)

Logo is from https://gitlab.com/ntgn/ascii-art, licenced under [Creative Commons Attribution 4.0 International][https://gitlab.com/ntgn/ascii-art/-/blob/main/LICENSE]

<h2>
  Dank Material Shell preview
</h2>

![dank-material-shell-preview](./assets/screenshots/2026-03-29-dms-preview.png)

All screenshots can be found [here](./assets/screenshots).
Wallpapers can be found [here](https://codeberg.org/voidptrx/wallpapers).

## Build steps
You may clone the repo with the following command:
```
nix-shell -p git --run "https://github.com/amanako/nix-config.git" && cd nix-config
```
This is preferably done in user's `home` folder.  
Users can be created by making a folder in [`users`](modules/users) directory and adding an entry to [`hosts.nix`](modules/den/hosts.nix).  
My current user is provided as an example.

## Credits
* https://nixos-and-flakes.thiscute.world (the cornerstone of my journey)
* https://den.oeiuwq.com/tutorials/default (base)
* https://github.com/AniviaFlome/nix-config ([fish][fish] and [zen-browser][zen-browser])
* https://github.com/zerokqx/ZNix (some [nixvim][nixvim] plugins)

## Caveats
<details>
  <summary><a href="https://gihub.com/0xc000022070/zen-browser-flake">zen-browser-flake</a></summary>  
  Only setting `*` as the profile name seems to yield expected results for containers and workspaces, 
  so I have resorted to that instead of `$username`. I cannot assert why at the moment.
</details>

<details>
  <summary> <a href="https://fcitx-im.org/wiki/Fcitx_5">fcitx5</a> </summary>
  I set up the `GTK_IM_MODULE` environment variable despite warnings since that seems to be  
  the only way for fcitx5 to work within <a href=https://noctalia.dev>noctalia</a>.  
  Details 
  <a href=https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland#TL;DR_Do_we_still_need_XMODIFIERS
    ,_GTK_IM_MODULE_and_QT_IM_MODULE?>here</a>.
</details>

[kitty]: https://sw.kovidgoyal.net/kitty
[neovim]: https://neovim.io
[yazi]: https://yazi-rs.github.io
[thunar]: https://docs.xfce.org/xfce/thunar/start
[niri]: https://niri-wm.github.io/niri
[noctalia]: https://noctalia.dev
[dms]: https://danklinux.com/
[zen-browser]: https://github.com/0xc000022070/zen-browser-flake 
[zathura]: https://pwmt.org/projects/zathura
[fcitx5]: https://fcitx-im.org/wiki/Fcitx_5
[awww]: https://codeberg.org/LGFae/awww
[fish]: https://fishshell.com
[ly]: https://codeberg.org/fairyglade/ly
[limine]: https://codeberg.org/Limine/Limine
[disko]: https://github.com/nix-community/disko
[impermanence]: https://github.com/nix-community/impermanence

[den]: https://den.oeiuwq.com
[SoC]: https://en.wikipedia.org/wiki/Separation_of_concerns
[TUI]: https://en.wikipedia.org/wiki/Text-based_user_interface
[C++]: https://en.wikipedia.org/wiki/C%2B%2B
[gruvbox]: https://duckduckgo.com/?q=gruvbox&iar=images&t=ffab
[VN]: https://en.wikipedia.org/wiki/Visual_novel
