# Tips

Following are some of tips from personal experience/trial and error(pending update and subject to change):

- If faced with choice, **prefer using [home manager as a NixOS module over standalone homes][hm]**.<br>
  Den allows declaring `den.homes` to achieve functionality for standalone home
  but I have deliberately omitted using it in configuration for convenience of rebuilding.

- Be sure to refer to [upstream documentation][docs] whenever met with difficulties.

- Use `nix-repl` when not sure why something doesn't work as intended. For den-specific stuff,
  reference [den's debug guide][den's debug quide].

[den's debug guide]: https://den.denful.dev/guides/debug/
[docs]: https://den.denful.dev/overview
[hm]: https://nix-community.github.io/home-manager/index.xhtml#ch-installation
