# Usage

General instructions for anyone willing to give config a try.
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

No matter the choice, option `repoRoot` should be set for either host or user,
where user preference overrides host's choice, making both of them eligible.

> While it is possible to read them from environment variables that behaviour is impure therefore avoided)<br>

See [Making a config](#making-a-config).

## Making a config

> Since flake uses [import-tree] ro recursively import files under modules/ as long as folders or files aren't prefixed with \_ and are tracked by git, their content will be considered by default.<br>
> That means it all boils down to individual preference. Therefore following will be my current preference which is subject to change.
> I accept corrections if I am mistaken somewhere or same can be achieved in an easier-to-understand fashion.

Users can be created by making an entry in [`users`](../modules/users) directory, whereas hosts are made by adding an entry under [`hosts`](../modules/hosts) folder.<br>
Following instruction apply equally to both of them, with difference which is explained below.

Duties are split among 2 folders: `entry` and `aspect`(optional), where:

1. `entry`: must begin with `den.hosts.${architecture}.${hostname}` for hosts and `den.hosts.${architecture}.${hostname}.users.${username}` for users:
    - Is made for den's definition and options which is tasked with actually creating host/user. Where applicable it should be prioritized over `aspect`.
    - Additionally, `userSettings` and `hostSettings` overrides for particular aspects are provided, and they can be specified here by accessing settings.
2. `aspect`: must begin with `den.aspects.${username}` for users and `den.aspects.${hostname}`:
    - Main purpose in inclusion of aspects user would like to use.
    - Is reserved for potential overrides for each of classes or quirks<br>

Also, den provides direct subaspects which can be used to modularize config by appending a `.` and specifying subaspect of an aspect.
Take a look at [`hosts`](../modules/hosts) specifying their hardware requirements separately or users to find those and other examples.<br>
Moreover, one user can be declared across multiple host and even have different den options per host.
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
Some users and hosts are provided as a starting point. Please reference [`users`](../modules/users) and [`hosts`](../modules/hosts).

There are some necessary options like `user.repoRoot` taking `host.repoRoot` as fallback value, which is supposed to represent directory of cloned repo, and should be set upfront.
Other than that some other options which are a must-have likely have an assertion forcing repo users to make a declaration.

When using impermanence: to persist configuration add directory containing configuration to `persistSystem` / `persistUser` quirk, either with:

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

Make sure your disk is formatted. [Disko][disko] is the recommended approach for this purpose.
If using this method running:

```
just disko $HOSTNAME
```

should run scripts to take care of partitioning.

If this is not the case, manual partitioning is required, I recommend taking a look at this [video].

```
# yes unix utility will answer y to all questions regarding usage of flake (trusted extra substituters and keys)
yes | nixos-install --no-channel-copy --no-bootloader --flake $REPO_DIR.$HOSTNAME

Copy configuration over to desired (or persisted) folder (likely in user's home).
cp -r $CONFIG_DIRECTORY $PATH_TO_FOLDER

# reboot into new configuration
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

For [limine]: check out [secure-boot-setup.md](../modules/den/aspects/core/boot/limine/secure-boot-setup.md).

[disko]: https://github.com/nix-community/disko
[import-tree]: https://github.com/denful/import-tree
[limine]: https://github.com/Limine-Bootloader/Limine
[nh]: https://github.com/nix-community/nh
[video]: https://www.youtube.com/watch?v=lUB2rwDUm5A
