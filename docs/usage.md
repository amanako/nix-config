# Usage

General instructinons for anyone willing to give a try to the config.
It isn't 100% foolproof at the moment so remain cautious.

<!-- toc -->

- [Cloning repo](#cloning-repo)
- [Making a config](#making-a-config)
- [Build steps](#build-steps)
- [Secure boot setup](#secure-boot-setup)

<!-- tocstop -->

## Cloning repo

Clone and enter the repo with either of the following commands:

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
Some users and hosts are provided as a starting point. Please reference [`users`](modules/users) and [`hosts`](modules/hosts).

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
persistUser.directories = [
  # Example path - made at $HOME/nix-config
  "nix-config"
  # It can be some upper path for example:
  "Documents"
  # and then copied as a subfolder
];
```

or

```
persistSystem.directories = [
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

For [limine]: checkout [secure-boot-setup.md](../modules/aspects/core/boot/limine/secure-boot-setup.md).

[video]: https://www.youtube.com/watch?v=lUB2rwDUm5A
[nh]: https://github.com/nix-community/nh
[limine]: https://github.com/Limine-Bootloader/Limine
[import-tree]: https://github.com/denful/import-tree
