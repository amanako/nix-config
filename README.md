<div align="center">
  <h1>:snowflake: NixOS configuration :snowflake:</h1>
</div>

<p align="center">
  <a href="https://nixos.org"><img alt="NixOS" src="https://img.shields.io/badge/NixOS-5277C3?logo=nixos&logoColor=fff" /></a>
  <a href="https://github.com/mightyiam/dendritic"> <img alt="Dendritic pattern" src="https://img.shields.io/badge/Dendritic--Pattern-Nix-informational?logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADIAAAA5CAYAAAB0+HhyAAAAAXNSR0IB2cksfwAAAARnQU1BAACxjwv8YQUAAAAgY0hSTQAAeiYAAICEAAD6AAAAgOgAAHUwAADqYAAAOpgAABdwnLpRPAAAAAlwSFlzAAALEwAACxMBAJqcGAAAAbpJREFUaN7tWcGuwyAMW6L9/y/nXTZpr4PiJA6sqJwmrZQYjOOk8igcZmbv3yIilWvpY9L4BHVpINXjBnIDKRrP1arEUjZlgIiokr0GS9mo1GoFN0uKJUMBdkCt96J00wyt5DUYALLv0ch96O3kCgD0O+INqvdslK5ypApLJnsBjea25o1Ai4gIOvH4XARMdAOO81rPaEWOYCiXB8RpZkfoNtPuDwUnsusoOBa1kFg0ojozqYaqpLJywioAp5cdOZ2KU8kkXmEEiiY3RhLsvYObXQdSiUppZC312HAm3bL+7WuToi9F5rROpGotyfgi5qXP+jeJJi4mIM96PS8mTEsSzcrZ4s5V6s7KB+mafYsT2eaObKtal80jmeDOAjmjLHutbbzW3u63zNglTae7HkF2aGY7CFlbq0DM7rQoWov8WvPhGK9mi6mK5oKnf/CO/flr9Bm5jNb/ZmaK7soqkKhg6L/sCDbpop/XmL7sK+6M48wIAfMTRrdBN6MeiTar3Q06zy5lKTMyk8ipbPNVt6SsHXVnKvKWsncUokGBfCuD15HgWqAzAEsTG6OpsYRaK8cN5AZyRSAzXfIf7j4IjUJ5XtMAAAAASUVORK5CYII=&logoColor=white" alt="Dendritic Pattern"/></a>
  <a href="https://flake.parts/"><img alt="Flake Parts"src="https://img.shields.io/badge/Flake%20Parts-Nix-informational?logoSize=auto&logoColor=white&logo=data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIj8+CjwhLS0gQ3JlYXRlZCB3aXRoIElua3NjYXBlIChodHRwOi8vd3d3Lmlua3NjYXBlLm9yZy8pIC0tPgoKPHN2ZwogICB3aWR0aD0iMzcuMzcyOTFtbSIKICAgaGVpZ2h0PSI0NS4zMTE5NzRtbSIKICAgdmlld0JveD0iMCAwIDM3LjM3MjkwOSA0NS4zMTE5NzMiCiAgIHZlcnNpb249IjEuMSIKICAgaWQ9InN2ZzExNTIiCiAgIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIKICAgeG1sbnM6c3ZnPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CiAgPGRlZnMKICAgICBpZD0iZGVmczExNDkiIC8+CiAgPGcKICAgICBpZD0ibGF5ZXIxIgogICAgIHRyYW5zZm9ybT0idHJhbnNsYXRlKC0zOS4xMTkzNDksLTExMy4yMDM5OCkiPgogICAgPHBhdGgKICAgICAgIGlkPSJwYXRoNDg5OCIKICAgICAgIHN0eWxlPSJmaWxsOiNmZmZmZmY7ZmlsbC1vcGFjaXR5OjE7c3Ryb2tlOm5vbmU7c3Ryb2tlLXdpZHRoOjcuOTM3O3N0cm9rZS1saW5lam9pbjpyb3VuZDtzdHJva2UtbWl0ZXJsaW1pdDo0O3N0cm9rZS1kYXNoYXJyYXk6bm9uZSIKICAgICAgIGQ9Im0gNDYuNTkzODI4LDExMy4yMDM5OCAtMy43MzcyNCw2LjQ3Mjk5IDcuNDc0NDc5LDEyLjk0NTk4IC03LjQ3NDQ3OSwxMi45NDY1IC0zLjczNzIzOSw2LjQ3Mjk5IDMuNzM3MjM5LDYuNDczNTEgaCA3LjQ3NDQ3OSBsIDcuNDc0NDc5LC0xMi45NDY1IDcuNDc0OTk2LDEyLjk0NjUgaCA3LjQ3NDQ3OSBsIDMuNzM3MjQsLTYuNDczNTEgLTMuNzM3MjQsLTYuNDcyOTkgLTcuNDc0NDc5LC0xMi45NDY1IC03LjQ3NDk5NiwtMTIuOTQ1OTggLTMuNzM3MjM5LC02LjQ3Mjk5IHoiIC8+CiAgPC9nPgo8L3N2Zz4K&link=https://flake.parts/"/></a>
</p>

## Design
* Config was made using [github:vic/den][den] configuration tool with [SoC][SoC] in mind
* Code is documented with tips I learned along the way and should assist with user comprehension

## Goals
* This config's main focus is **[TUI][TUI] experience** improvement via various tweaks, plugins, integrations etc. to elevate everyday terminal tasks.
  Most of the software comprising this config are aiming to assist this goal.
* The config aims to be **keyboard-driven** wherever I found so to be fitting.
* All choices are usually made with regard to **elegance** and **privacy** as well.
* **[Neovim][neovim]** is pushed to the edges and is meant to be used as an **all-encompassing text editor**. Currently it is equiped with capabilities for my workflow ([C++][C++] mostly) but will likely be extended in the future.
* **Fallback GUI software** is present for some inescapable situations.
* **Uniformness** prefered, therefore config is made to employ widely-supported **[gruvbox][gruvbox] theme** for most of the software.
* **Light gaming** software packed as well, I use it primarily for [VNs][VN]

## Included

<div align="center">

  |  Functionality |   Software                                                                                                |
  |:--------------:|:---------------------------------------------------------------------------------------------------------:|
  | Shell          | [fish][fish]                                                                                              |
  | Terminal       | [kitty][kitty]                                                                                            | 
  | File Editor    | [neovim][neovim] via [nixvim][nixvim]                                                                     |
  | File Manager   | [yazi][yazi], with [thunar][thunar] as fallback                                                           |
  | Compositor     | [wayland][wayland]                                                                                        |
  | Window Manager | [niri][niri]                                                                                              |
  | Quickshell     | [noctalia][noctalia], with [dms][dms] as another option                                                   |
  | Browser        | [zen-browser][zen-browser]                                                                                |
  | Input Method   | [fcitx5][fcitx5]                                                                                          |
  | Display Manager| [ly][ly]                                                                                                  |
  | Boot Loader    | [limine][limine], for setup check out [limine's README](./modules/nixos/system/hardware/limine/limine.nix)|
  | Document Viewer| [okular][okular]                                                                                          |

</div>

and many other smaller, however equally significant ones...

## Screenshoots

![noctalia-overview](./assets/screenshots/2026-03-14-noctalia-preview.png)
![features-overview](./assets/screenshots/2026-03-14-tui-features-preview.png)

## Build steps
You may clone the repo with the following command:
```
nix-shell -p git --run "git clone https://codeberg.org/abyssal-twilight/nix-config.git" && cd nix-config
```
This is preferably done within user's `home` folder(`~`), but anything is fine.  
Users can be created by making a folder in [`users`]('./modules/users/') directory and adding an entry to [`hosts.nix`]('./modules/flake/hosts.nix')  
My current user is provided as an example.

## Inspirations
* https://nixos-and-flakes.thiscute.world (the cornerstone of my journey)
* https://codeberg.org/Moortu/dotfiles (dendritic design with den)
* https://github.com/AniviaFlome/nix-config ([fish][fish] and [zen-browser][zen-browser]))
* https://github.com/zerokqx/ZNix (some [nixvim][nixvim] plugins)

## Caveats
<details>
  <summary><a href="https://gihub.com/0xc000022070/zen-browser-flake">zen-browser-flake</a></summary>  
  Only setting `*` as the profile name seems to yield expected results for containers and workspaces, 
  so I have resorted to that instead of `$username`. I cannot assert why at the moment.
</details>

<details>
  <summary><a href="https://fcitx-im.org/wiki/Fcitx_5">fcitx5</a></summary>
  I set up the `GTK_IM_MODULE` environment variable despite warnings since that seems to be  
  the only way for fcitx5 to work within <a href=https://noctalia.dev>noctalia</a>.  
  Details 
  <a href=https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland#TL;DR_Do_we_still_need_XMODIFIERS
    ,_GTK_IM_MODULE_and_QT_IM_MODULE?>here</a>.
</details>

[fish]: https://fishshell.com
[kitty]: https://sw.kovidgoyal.net/kitty
[neovim]: https://neovim.io
[nixvim]: https://github.com/nix-community/nixvim
[yazi]: https://yazi-rs.github.io
[wayland]: https://wayland.freedesktop.org
[niri]: https://niri-wm.github.io/niri
[noctalia]: https://noctalia.dev
[zen-browser]: https://github.com/0xc000022070/zen-browser-flake 
[fcitx5]: https://fcitx-im.org/wiki/Fcitx_5
[ly]: https://codeberg.org/fairyglade/ly
[limine]: https://codeberg.org/Limine/Limine
[okular]: https://okular.kde.org

[den]: https://den.oeiuwq.com
[SoC]: https://en.wikipedia.org/wiki/Separation_of_concerns
[TUI]: https://en.wikipedia.org/wiki/Text-based_user_interface
[C++]: https://en.wikipedia.org/wiki/C%2B%2B
[gruvbox]: https://duckduckgo.com/?q=gruvbox&iar=images&t=ffab
[VN]: https://en.wikipedia.org/wiki/Visual_novel
