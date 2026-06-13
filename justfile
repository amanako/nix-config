# Display all recipes
help:
    just --list

# Update flake inputs using "write-flake" app of flake-file
fwrite:
    nix --accept-flake-config run {{ repo-root }}#write-flake

# Check configuration of flake.nix from repo root
fcheck:
    nix --accept-flake-config flake check -L {{ repo-root }}

# Update one or more flake inputs, all when no inputs specified
fupdate *inputs:
    nix --accept-flake-config flake update -L {{ inputs }} --flake {{ repo-root }}

# Rebuild and activate config with nh and make it the default boot entry
rebuild-switch:
    nh os switch --accept-flake-config --ask --diff always --show-trace --hostname {{ hostname }}

# Rebuild config with nh and make it the default boot entry, activated after reboot
rebuild-boot:
    nh os boot --accept-flake-config --ask --diff always --show-trace --hostname {{ hostname }}

# Run disko configuration for current host
disko:
    nix --accept-flake-config run {{ repo-root }}#{{ hostname }}-disko

# Spin up a virtual machine for current host
vm:
    nix --accept-flake-config run {{ repo-root }}#{{ hostname }}-vm

# Enter nix repl with flake.nix from repo root
repl:
    nix --accept-flake-config repl {{ repo-root }}#

# Pull in changes from remote
[arg("branch", help="Branch to restore flake.nix and flake.lock files from")]
pull-flake branch="main":
    # Fetch latest commits
    git fetch origin

    # Fetch flake.lock
    git restore --source=origin/{{ branch }} -- flake.nix flake.lock

hostname := `uname -n`
repo-root := `git rev-parse --show-toplevel`

alias h := help
alias fw := fwrite
alias fc := fcheck
alias fu := fupdate
alias rs := rebuild-switch
alias rb := rebuild-boot
alias d := disko
alias r := repl
alias pf := pull-flake
