# Disks & encryption

How the disk layout is assembled declaratively with disko, and how the LUKS
aspect layers full-disk encryption on top. Most of the logic lives under
`modules/den/aspects/core/disks/`.

<!-- toc -->

- [The `diskoConfig` quirk](#the-diskoconfig-quirk)
  * [The collector fold](#the-collector-fold)
- [Standard layout](#standard-layout)
  * [`disko` and `esp`](#disko-and-esp)
  * [`root-btrfs` and `swap-subvol`](#root-btrfs-and-swap-subvol)
  * [`luks`](#luks)
- [Why an ESP is mandatory](#why-an-esp-is-mandatory)
  * [The ESP is included by default](#the-esp-is-included-by-default)
- [LUKS encryption](#luks-encryption)
  * [Enabling the aspect](#enabling-the-aspect)
  * [Password mode (default)](#password-mode-default)
  * [Keyfile mode (unattended boot)](#keyfile-mode-unattended-boot)
  * [Keyfile via sops-nix](#keyfile-via-sops-nix)
  * [First-time setup caveats](#first-time-setup-caveats)

<!-- tocstop -->

## The `diskoConfig` quirk

`den.quirks.disko` is a data channel: every disk aspect contributes a fragment
under `diskoConfig`, and the collector folds all fragments into the single
`disko.devices.disk.main` config. The channel has three keys:

- `partitions.<name>` — a GPT partition spec (contributed by `esp`,
  `root-btrfs`, …)
- `subvolumes.<name>` — btrfs subvolume specs that get injected into the btrfs
  root content (`swap-subvol`, plus the `/root` and `/nix` defaults the
  collector declares itself)
- `luks` — an optional single luks wrapper applied to the partition named by
  its `target`

### The collector fold

`disko-collector.nix` (a `den.aspects.core.disks.disko-collector`) assembles the
final config:

1. Folds `partitions` / `subvolumes` contributions with `lib.mergeAttrsList`.
2. `applyDefaults` adds `compress=zstd` / `noatime` mount options to subvolumes
   that don't set their own.
3. `wrapLuks` wraps the partition named by the luks contribution's `target`
   (default `"root"`) in the luks layer, regardless of its filesystem type.
4. `injectSubvolumes` threads the collected subvolumes into **btrfs** content,
   seeing through the luks layer; non-btrfs content is left untouched.

The only host setting the collector needs is
`settings.core.disks.disko-collector.devicePath`.

## Standard layout

| Aspect            | Purpose                                                    |
| ----------------- | ---------------------------------------------------------- |
| `disko`           | Imports the disko NixOS module; includes collector + `esp` |
| `esp`             | EFI System Partition (vfat, mounted `/boot`, type `EF00`)  |
| `root-btrfs`      | btrfs root partition filling the rest of the disk          |
| `swap-subvol`     | swap subvolume with a swapfile                             |
| `luks`            | opt-in: encrypts the partition named by `target`      |

Hosts list the ones they need in `modules/hosts/<host>/aspect/hardware.nix`.
Unencrypted hosts today include `disko` + `root-btrfs` + `swap-subvol`.

### `disko` and `esp`

`disko` is what every host includes; it imports `inputs.disko.nixosModules.disko`
and `includes` the collector **and** `esp` by default. `esp` is configurable via
`settings.core.disks.esp.size` (default `"4G"`, nebula overrides with `"2G"`).

### `root-btrfs` and `swap-subvol`

`root-btrfs` contributes `partitions.root` as a `100%` btrfs partition
(`extraArgs = ["-f"]`). `swap-subvol` contributes
`subvolumes."/swap"` with a swapfile sized via
`settings.core.disks.swap-subvol.swapSize` (default `"16G"`).

### `luks`

Optional. See [LUKS encryption](#luks-encryption).

## Why an ESP is mandatory

An EFI System Partition is a **UEFI requirement, not a bootloader requirement**.
The ESP holds the bootloader's EFI binary and the kernels it loads; every
supported boot path in this repository is UEFI:

- `core.boot.limine` sets `boot.loader.limine.efiSupport = true` and
  `canTouchEfiVariables = true`
- `core.boot.limine.secure-boot` and the `boot.tweaks.*` aspects are UEFI-only

The only layout that avoids an ESP is BIOS/legacy boot
(GRUB or limine installed to the MBR), which this repository does not support.
Consequently there is no supported configuration of `disko` without an ESP.

### The ESP is included by default

Because the ESP is mandatory for every supported layout, `disko` `includes`
`esp` rather than asking each host to list it. An earlier revision kept `esp`
opt-in and guarded against forgetting it with a `hostConflicts` assertion
(`disko-collector` asserting a partition with `type "EF00"` exists). Including
`esp` by default made that assertion dead code, so it was removed. A host that
wants a genuinely different layout (ESP at `/efi`, btrfs boot subvolume, BIOS
boot) should not use the stock `disko` aspect at all.

## LUKS encryption

`luks` encrypts everything except `/boot`: the collector wraps the partition
named by `target` (default `"root"`) in a luks layer, **independent of its
filesystem type** — btrfs, ext4, zfs, … all work, since disko's luks content
accepts any device type. For btrfs layouts the swap subvolume lives inside the
encrypted volume. Two unlock modes are supported; pick one.

### Enabling the aspect

```nix
# modules/hosts/<host>/aspect/hardware.nix
includes = [
  den.aspects.core.disks.disko
  den.aspects.core.disks.root-btrfs
  den.aspects.core.disks.luks
  den.aspects.core.disks.swap-subvol
];
```

The aspect asserts (fail-fast at build) that the collector actually wrapped the
partition named `target` — so `luks` is valid alongside any root partition
aspect that contributes a partition with that name (e.g. `root-btrfs`).

Beware: `impermanence` as configured here contributes btrfs subvolumes (persist
dir, `/home`), which are silently dropped on non-btrfs layouts — impermanence
is effectively btrfs-only today.

### Password mode (default)

No settings needed. Disko prompts for a password when formatting, and the
initrd prompts at every boot:

```nix
settings.core.disks.luks.name = "cryptroot"; # default
```

### Keyfile mode (unattended boot)

```nix
settings.core.disks.luks.keyFile = "/boot/keyfile";
```

The keyfile is copied into the initrd at rebuild time
(`boot.initrd.secrets."/boot/keyfile" = "/boot/keyfile"`) and
`boot.initrd.luks.devices.cryptroot.keyFile` points at it, so no password is
prompted. `keyFileSize` (default 4096) must match the actual keyfile size.

This repo runs the systemd initrd (`boot.initrd.systemd.enable`), where
password fallback is *implied*: if the keyfile is missing or fails, stage 1
automatically prompts for the LUKS password. That is why the aspect exposes no
`fallbackToPassword` knob — nixpkgs forbids it (and its counterpart,
scripted stage 1, is deprecated).

### Keyfile via sops-nix

Instead of committing a cleartext keyfile, keep it as an age-encrypted sops
secret in the repo. It decrypts to a store path at build time and is baked into
the initrd, so any machine holding the host's age key can rebuild it. Requires
the `sops-host` aspect and the one-time setup from `docs/sops-secrets.md`.

A LUKS keyfile is binary, so encrypt it with sops' whole-file mode (not the
interactive `sops <file>` editing flow, which expects YAML):

```sh
# 1. generate the keyfile; size must match `keyFileSize` (default 4096)
dd if=/dev/urandom of=/tmp/luks.key bs=512 count=8

# 2. register it as a LUKS slot on a running host (do this AFTER first boot in
#    password mode; disko's luksFormat can't read the sops store path yet).
#    Prompts for an existing passphrase.
sudo cryptsetup luksAddKey /dev/disk/by-partlabel/disk-main-root /tmp/luks.key

# 3. encrypt it into the host's secrets dir. Pass the recipients explicitly
#    (the host's age key + your own, so you can manage it) — from assets/, the
#    whole-file mode also works, but --age is deterministic regardless of cwd.
cd assets
nix shell nixpkgs#sops nixpkgs#age -c sops --encrypt \
  --input-type binary --output-type yaml \
  --age "age1<host-...>,age1<you-...>" \
  < /tmp/luks.key > hosts/<hostname>/secrets/luks-keyfile.yaml

# 4. commit it
git add hosts/<hostname>/secrets/luks-keyfile.yaml
```

Recipients are the age keys from `assets/.sops.yaml` (host key via
`ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub`). For consistency also add a
`creation_rules` entry for this host's secrets dir there (see nebula's).

The encrypted file holds the whole keyfile under a single `data` value, so
declare the secret with `key = "data"`:

```nix
# host aspect, requires the sops-host aspect
sops.secrets.luks-keyfile = {
  key = "data";
  sopsFile = host.settings.security.sops-host.secretsDir + "/luks-keyfile.yaml";
};
```

```nix
settings.core.disks.luks = {
  keyFile = "/boot/keyfile";
  keyFileSecret = "luks-keyfile";
};
```

`sops.secrets.luks-keyfile.path` then holds exactly the bytes registered as the
slot in step 2; rebuild (`just rs`) to bake it into the initrd. See
`docs/sops-secrets.md` for age-key setup and the "0 successful groups"
troubleshooting.

### First-time setup caveats

- **Disko formats `/boot` itself.** In keyfile mode disko also uses
  `settings.keyFile` during `luksFormat`, so the keyfile must already exist at
  that path when disko runs. The reliable first-time flow is: format with
  password mode, boot, generate the keyfile on the ESP, add it as a luks key
  slot (`cryptsetup luksAddKey <device> /boot/keyfile`), then switch the host
  to keyfile mode.
