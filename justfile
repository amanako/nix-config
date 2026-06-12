# Check configuration of flake.nix from repo root
fcheck:
    nix --accept-flake-config flake check -L {{ repo-root }}

# Display all recipes
help:
    just --list

# Rebuild and activate config with nh and make it the default boot entry
rebuild-switch:
    nh os switch --accept-flake-config --ask --diff always --show-trace --hostname {{ hostname }}

# Rebuild config with nh and make it the default boot entry, activated after reboot
rebuild-boot:
    nh os boot --accept-flake-config --ask --diff always --show-trace --hostname {{ hostname }}

# Search for packages with nh via https://search.nixos.org/ (limited to 10 matches)
search pkg:
    nh search --limit 10 {{ pkg }}

# Clean with nh
clean:
    nh clean all --keep 5 --optimise

# Break into nix repl with flake.nix from repo root
repl:
    nix repl {{ repo-root }}# --accept-flake-config

hostname := `uname -n`
repo-root := `git rev-parse --show-toplevel`

alias fc := fcheck
alias h := help
alias rs := rebuild-switch
alias rb := rebuild-boot
alias s := search
alias c := clean
alias r := repl
