# Included

Here is a table representing software along with it's functionality whose aspects can be found in `modules/den/aspects`(../modules/den/aspects).
Refer to these as it will be updated from time to time to conform to overall design.

<div align="center">

**Shell & Terminal**

| Functionality | Software |
|:----------------:|:---------------------------------------------------------------------:|
| Terminal | [kitty] |
| Shell | [bash] / [fish] / [nushell] |
| Terminal Multiplexer | [zellij] |
| Shell Prompt | [starship] |

**Core — Editors & Files**

| Functionality | Software |
|:----------------:|:---------------------------------------------------------------------:|
| File Editor | [neovim](native and [nixvim]) / [helix] |
| File Manager | [yazi] / [thunar] |

**Desktop**

| Functionality | Software |
|:----------------:|:---------------------------------------------------------------------:|
| Window Manager | [niri] |
| Status Bar | [waybar] |
| Browser | [zen-browser] |
| Document Viewer | [zathura] |
| Input Method | [fcitx5] |
| Wallpaper Manager| [awww] |
| Notifications | [dunst] |
| Application Launcher | [vicinae] |
| Media Player | [mpv] |
| Desktop Environment | [noctalia] (v5 beta) |
| Desktop Shell | [noctalia-shell] (legacy v4) / [dms] |

**Boot & Layout**

| Functionality | Software |
|:----------------:|:---------------------------------------------------------------------:|
| Display Manager | [ly] / [lemurs] |
| Boot Loader | [limine] |
| Memory layout | btrfs (unencrypted by default, [luks] optional) via [disko] + [impermanence] |

**System / Nix**

| Functionality | Software |
|:----------------:|:---------------------------------------------------------------------:|
| Nix Implementation | [lix] |
| Nix CLI Helper | [nh] |
| Misc (bleeding-edge) | [chaotic-nyx] |

**Hardware**

| Functionality | Software |
|:----------------:|:---------------------------------------------------------------------:|
| Power / Battery | [tlp] / [thermald] / [auto-cpufreq] |

**Dev tooling**

| Functionality | Software |
|:----------------:|:---------------------------------------------------------------------:|
| Fuzzy Finder | [fzf] |
| Cat Replacement | [bat] |
| LS Replacement | [eza] |
| CD Replacement | [zoxide] |
| Directory Env | [direnv] |
| Directory Env Daemon | [direnv-instant] |
| VCS | [jujutsu] |
| AI Coding Agent | [vix] |
| Nix Search Index | [nix-index-database] |
| Theme Framework | [stylix] |

**Security**

| Functionality | Software |
|:----------------:|:---------------------------------------------------------------------:|
| Secret Management | [sops-nix] (host + user) |

**Utility**

| Functionality | Software |
|:----------------:|:---------------------------------------------------------------------:|
| Memorization | [anki] |
| Local File Share | [localsend] |
| YouTube TUI | [youtube-tui] |

**Gaming**

| Functionality | Software |
|:----------------:|:---------------------------------------------------------------------:|
| Gaming Optimizations | [nix-gaming] |

**Kernel**

| Functionality | Software |
|:----------------:|:---------------------------------------------------------------------:|
| Optimized Kernel | [cachyos-kernel] |

</div>

[awww]: https://codeberg.org/LGFae/awww
[disko]: https://github.com/nix-community/disko
[luks]: https://gitlab.com/cryptsetup/cryptsetup
[dms]: https://danklinux.com/
[dunst]: https://dunst-project.org
[fcitx5]: https://fcitx-im.org/wiki/Fcitx_5
[yazi]: https://yazi-rs.github.io
[zathura]: https://pwmt.org/projects/zathura
[zen-browser]: https://github.com/0xc000022070/zen-browser-flake
[niri]: https://niri-wm.github.io/niri
[nixvim]: https://github.com/nix-community/nixvim
[noctalia]: https://noctalia.dev
[noctalia-shell]: https://github.com/noctalia-dev/noctalia/tree/legacy-v4
[kitty]: https://sw.kovidgoyal.net/kitty
[limine]: https://github.com/Limine-Bootloader/Limine
[ly]: https://codeberg.org/fairyglade/ly
[lemurs]: https://github.com/coastalwhite/lemurs
[neovim]: https://neovim.io
[fish]: https://fishshell.com
[impermanence]: https://github.com/nix-community/impermanence
[thunar]: https://docs.xfce.org/xfce/thunar/start
[nushell]: https://www.nushell.sh
[zellij]: https://zellij.dev
[helix]: https://helix-editor.com
[starship]: https://starship.rs
[waybar]: https://github.com/Alexays/Waybar
[vix]: https://github.com/get-vix/vix
[stylix]: https://github.com/nix-community/stylix
[nix-index-database]: https://github.com/nix-community/nix-index-database
[sops-nix]: https://github.com/Mic92/sops-nix
[cachyos-kernel]: https://github.com/xddxdd/nix-cachyos-kernel
[mpv]: https://mpv.io
[chaotic-nyx]: https://github.com/chaotic-cx/nyx
[lix]: https://lix.systems
[nh]: https://github.com/viperML/nh
[tlp]: https://linrunner.de/tlp
[thermald]: https://github.com/intel/thermal_daemon
[auto-cpufreq]: https://github.com/AdnanHodzic/auto-cpufreq
[fzf]: https://github.com/junegunn/fzf
[bat]: https://github.com/sharkdp/bat
[eza]: https://github.com/eza-community/eza
[zoxide]: https://github.com/ajeetdsouza/zoxide
[direnv]: https://direnv.net
[direnv-instant]: https://github.com/nix-community/nix-direnv
[jujutsu]: https://github.com/jj-vcs/jj
[bash]: https://www.gnu.org/software/bash
[vicinae]: https://vicinae.com
[anki]: https://apps.ankiweb.net
[localsend]: https://localsend.org
[youtube-tui]: https://github.com/dertuxmalwieder/youtube-tui
[nix-gaming]: https://github.com/fufexan/nix-gaming
