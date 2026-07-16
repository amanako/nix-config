# Managing secrets with sops-nix

<!-- toc -->

- [Relevant folders/files](#relevant-foldersfiles)
- [One-time setup](#one-time-setup)
- [Creating a secret (example: OpenRouter API key)](#creating-a-secret-example-openrouter-api-key)
- [Consuming the secret in Nix](#consuming-the-secret-in-nix)
  * [Den setup](#den-setup)
  * [Expose secret](#expose-secret)
  * [Use in aspect](#use-in-aspect)
    + [Pattern A — the consumer reads a key file](#pattern-a--the-consumer-reads-a-key-file)
    + [Pattern B — the consumer wants an environment variable](#pattern-b--the-consumer-wants-an-environment-variable)
- [Troubleshooting](#troubleshooting)
  * [`sops-nix.service` fails: "Error getting data key: 0 successful groups required, got 0"](#sops-nixservice-fails-error-getting-data-key-0-successful-groups-required-got-0)

<!-- tocstop -->

This repo uses [sops-nix](https://github.com/Mic92/sops-nix) with **age**
encryption. (for now not with gpg support from repo itself) Encrypted secret files live under host/user-scoped directories
(`assets/hosts/<hostname>/secrets/` and `assets/users/<username>/secrets/`) and
are committed to git; the repo-root `assets/.sops.yaml` file decides which age
keys can decrypt them. This document walks through adding a real secret, using
an OpenRouter API key as the example.

## Relevant folders/files

| Path | Purpose |
|---|---|
| `assets/.sops.yaml` | Recipients (age public keys) and per-directory `creation_rules`. Repo-wide. |
| `assets/hosts/<hostname>/secrets/*.yaml` | Host-scoped encrypted secret files. |
| `assets/users/<username>/secrets/*.yaml` | User-scoped encrypted secret files. |
| `<~/path-to-age-key-file>` | **Private** age key. Conventionally `~/.config/sops/age/keys.txt`; can be specified via `settings.security.sops-user.ageKeyFile`. Not part of the repo. |
| `/etc/ssh/<key-file>` or `<path-to-age-key-file>` | Host key - private ssh key or age key; sops-nix derives the host's age recipient from it. Not part of the repo. |
| `~/.config/sops-nix/secrets/<name>` | Symlink to the decrypted secret; points into `$XDG_RUNTIME_DIR/secrets.d/`. Not part of the repo. |

## One-time setup

1. Generate user age key. Write it to the path the
   repo expects — by default `user.settings.sops-user.security.ageKeyFile`. (look at [den-setup](#den-setup) below)
   For example:

   ```sh
   mkdir -p ~/.config/sops/age
   nix shell nixpkgs#age -c age-keygen -o ~/.config/sops/age/keys.txt
   ```

   This writes the private key to the file **and prints the public key** on the
   line starting with `Public key: age1...` — copy that now.

2. Get your age public key (only if you didn't copy it in step 1) and each
   host's age public key:

   ```sh
   # your user key, re-derived from the private key file
   nix shell nixpkgs#age -c age-keygen -y ~/.config/sops/age/keys.txt

   # For ssh-to-age conversion, otherwise repear similarly to command above
   # Requirement: /etc/ssh mounted as a a filesystem
   nix shell nixpkgs#ssh-to-age -c ssh-to-age < /etc/ssh/ssh_host_ed25519_pub
   # or from a remote:  ssh-keyscan <host> | nix shell nixpkgs#ssh-to-age -c ssh-to-age
   ```

   > One advantage of generating age key for host as well is that you don't need to have `/etc/ssh` mounted as filesystem like
   > with age key file approach where only key is enough to persist
   > Just reference key folder in ageKeyFile.

   > *NOTE: For ephemeral hosts save the age key file directly within persisted directory
   > After that run rebuild-switch (`just rs`) to rebuild configuration in place*
   > This way file will be copied to regular directory and available after reboot

3. Paste those public keys into `assets/.sops.yaml` as the `&user_...` /
   `&host_...` anchors under `keys:`, referencing them in the `creation_rules`
   `key_groups` for that host's/user's secret directory.

## Creating a secret (example: OpenRouter API key)

Secrets are scoped by directory: put **host** secrets under
`assets/hosts/<hostname>/secrets/` and **user** secrets under
`assets/users/<username>/secrets/`. The OpenRouter key is a user secret, so it
goes under `assets/users/${username}/secrets/`.

sops discovers `assets/.sops.yaml` by walking **up from the current directory**,
so every `sops` command must be run from inside `assets/` (or deeper). Running from the
repo root will not find the config.

1. Create and encrypt in one step.

   ```sh
   # Needs to be done from `assets` directory since .sops.yaml resides there
   cd assets
   nix shell nixpkgs#sops -c sops "users/${username}/secrets/openrouter-api-key.yaml"
   ```

   > Regarding naming it is easiest if you name file after the variable you want to use in config
   > This is because internally secret attribute sets members `key` and `name` are set to the name of the key
   > If not doing so, just know that you likely need to change those to match the name of the file just created

   - Clear default contents of file.
   - Type `<secret-key-name>: <contents>` and paste in contents of secret and save file.

2. Make sure the file is tracked by git - `git add <path-to-secret-file>`

## Consuming the secret in Nix

### Den setup

1. For hosts

- Include `den.aspects.security.sops-host`
- Provide `ageKeyFile` or `sshKeyPaths` in `host.settings.sops-host.security`

2. For users

- Include `den.aspects.security.sops-user`
- Provide `ageKeyFile` (must not have password set)

### Expose secret

As for example: Declare the secret and point it at the encrypted file. Because api key is a
user-level secret, declare it in a `hm` block (e.g.
`modules/users/lunar-scar/aspect/secrets.nix`):

```nix
hm = {user, ...}: {
  # ...existing config...

  sops.secrets.openrouter-api-key = {
    sopsFile = user.settings.security.sops-user.secretsDir + "/openrouter-api-key.yaml";
  };
}
```

For now I advise not using defaultSopsFile for better control and easier management, so pass `sopsFile` explicitly for each secret.
For a **host** secret, declare it in a
`nixos` block included by host instead — the same `sops.secrets.<name>` option applies.

### Use in aspect

Among the patterns listed below Pattern A should be preferred because it's easier to setup
and there is a fool-proof ways for secrets not to leak into `/nix/store`.

#### Pattern A — the consumer reads a key file

> Attempts are made to provide most ease for users by already making aspects which take in secrets so that this step can be skipped
> Nevertheless, if that isn't the case continue reading

If the program accepts a path to a file containing the secret,
reference the decrypted path directly:

```nix
# wherever the agent is configured:
programs.some-agent.settings.api_key_file =
  config.sops.secrets.openrouter-api-key.path;
```

`config.sops.secrets.openrouter-api-key.path` resolves to a symlink at
`~/.config/sops-nix/secrets/openrouter-api-key`, which points into the runtime
dir (e.g. `$XDG_RUNTIME_DIR/secrets.d/openrouter-api-key` for a user secret).
The symlink target under `secrets.d/` is where the cleartext actually lives.

#### Pattern B — the consumer wants an environment variable

Render a small env file with `sops.templates`, then source it or use it as an
`EnvironmentFile`:

```nix
sops.templates."openrouter.env" = {
  content = ''
    export OPENROUTER_API_KEY="${config.sops.placeholder.openrouter-api-key}"
  '';
  owner = config.home.username;
  mode = "0400";
};

# e.g. a systemd user service for the agent:
systemd.user.services.some-agent.Service.EnvironmentFile =
  config.sops.templates."openrouter.env".path;
```

The `config.sops.placeholder.<name>` is the decrypted value, substituted during
the activation phase (cleartext never touches the Nix store).

## Troubleshooting

### `sops-nix.service` fails: "Error getting data key: 0 successful groups required, got 0"

This means sops could not find an age key matching the secret's recipient: the
encrypted file was encrypted for a **different** age key than the one in key file.
Common causes:

- The secret was created/edited without the repo's `assets/.sops.yaml` in scope
  (e.g. a default config generated a fresh key), so the recipient baked into the
  file is not the `age1...` key from `.sops.yaml`.
- Age key was rotated/replaced but secret was not re-encrypted.

Check: derive the public key from your key file and compare it to the recipient
in the `.sops.yaml` rule and in the encrypted file's `sops.age` block:

```sh
nix shell nixpkgs#age -c age-keygen -y ~/.config/sops/age/keys.txt
```

Fix: re-encrypt the file so its recipient matches `.sops.yaml`. From `assets/`:

```sh
cd assets
# if it still decrypts, just re-save to re-encrypt:
nix shell nixpkgs#sops -c sops edit users/lunar-scar/secrets/openrouter-api-key.yaml
# if it cannot be decrypted, recreate it (write plaintext, then let sops encrypt
# it using the creation_rules discovered from assets/.sops.yaml):
nix shell nixpkgs#sops -c sops users/lunar-scar/secrets/openrouter-api-key.yaml
```

Then `systemctl --user restart sops-nix.service`.
