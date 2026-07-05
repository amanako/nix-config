# Development

[nix-direnv] is automatically enabled for all users.
To begin with development you are advised to use `direnv allow .` in repo root.
This enables automatic loading of environment and all packages each time you `cd` into directory,
all while caching results for great responsiveness.
If that doesn't fit you(possibility of running arbitrary dangerous commands)
simply run `nix develop` to enter shell with all dependencies.

## Just commands
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

## Pulling remote changes

In case of remote updates, run `just pull-flake` to grab latest `flake.nix` and `flake.lock` files.
Works if no changes were made to local flake files. Otherwise manual intervention with `git rebase`
is required.

[nix-direnv]: https://github.com/nix-community/nix-direnv
