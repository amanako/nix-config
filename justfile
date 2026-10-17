# Display all recipes
[private]
help:
    just --list

# Update flake inputs using "write-flake" app of flake-file
[group('flake')]
fwrite:
    nix --accept-flake-config run .#write-flake

# Update one or more flake inputs, all when no inputs specified
[group('flake')]
fupdate *inputs:
    just fwrite
    nix --accept-flake-config flake update -L {{ inputs }} --flake .
    just fwrite

# Check all flakes validity
[group('flake')]
fcheck:
    nix flake check -L --accept-flake-config --show-trace --all-systems

# Rebuild and activate config of a host with nh and make it the default boot entry, defaults to current host
[group('config')]
rebuild-switch host=hostname: ensure-zen-closed
    just fwrite
    nh os switch --accept-flake-config --ask --diff always --show-trace --hostname {{ host }}

# Rebuild config of a host with nh and make it the default boot entry, activated after reboot, defaults to current host
[group('config')]
rebuild-boot host=hostname:
    just fwrite
    nh os boot --accept-flake-config --ask --diff always --show-trace --hostname {{ host }}

# Test new config, defaults to current host
[group('config')]
test host=hostname:
    just fwrite
    nh os test --accept-flake-config --ask --diff always --show-trace --hostname {{ host }}

# Run disko configuration for a host, defaults to current host
[group('packages')]
disko host=hostname:
    nix --accept-flake-config run .#diskoScripts.{{ host }}

# Build a raw SD card image for a host, defaults to current host
[group('packages')]
image host=hostname:
    nix --accept-flake-config build .#images.{{ host }} --print-build-logs

# Spin up a virtual machine for a host, defaults to current host
[group('packages')]
vm host=hostname:
    nix --accept-flake-config run .#vms.{{ host }}

# Enter nix repl with flake.nix from repo root
[group('packages')]
repl:
    nix --accept-flake-config repl .#

# Pull in changes from remote
[arg("branch", help="Branch to restore flake.nix and flake.lock files from")]
[group('flake')]
pull-flake branch="main":
    # Fetch latest commits
    git fetch origin

    # Fetch flake.lock
    git restore --source=origin/{{ branch }} -- flake.nix flake.lock

[group('assertions')]
[private]
ensure-zen-closed:
    #!/usr/bin/env sh
    if pgrep zen > /dev/null; then
    echo "Zen browser is currently running, please close it before proceeding."
    exit 1
    fi

hostname := `hostname`

alias h := help
alias fw := fwrite
alias fu := fupdate
alias rs := rebuild-switch
alias rb := rebuild-boot
alias d := disko
alias r := repl
alias pf := pull-flake
alias t := test
alias fc := fcheck
