# Anki key file setup

This document outlines steps to obtain and setup anki key file, configured as `hm.programs.anki.profiles.${profileName}.sync`
It is intended for users _wanting to use anki sync with official anki server_.
There are other ways available but this requires minimal work, since this secret alone is enough.

1. To get the sync key file contents:
  - Rebuild with this aspect included (or at least `hm.programs.anki.enable = true`)
  - Go to Tools > Preferences > Syncing and click on "Log In" button in AnkiWeb Account section
  - Input credentials and press enter
  - First a prompt mentioning sync-successful will appear, you may reject press "No"
  - When prompted with a message titled "NixOS Info" regarding "Anki setting are currently being managed by Home Manager. Changes to certain settings won't be saved." click "Show details..." button
  - Copy the <key> from message "syncKey changed from \`None\` to \`<key>...\`", without the backticks(``) (username is not necessary)

2. Encrypt that key for user following sops-management guide in `docs/sops-management.md`,
saving file as `anki-key.yaml` and set `config.sops.secret.anki-key` in user aspect

Upstream documentation on home manager module can be found [here][upstream].

[upstream]: https://nix-community.github.io/home-manager/options/home-manager/programs/anki.html#opt-programs.anki.profiles._name_.sync.keyFile
