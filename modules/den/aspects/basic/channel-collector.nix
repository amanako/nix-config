{
  lib,
  inputs,
  ...
}: let
  # Every nixpkgs flake input, keyed by its input name (e.g. "nixpkgs",
  # "nixpkgs-stable"). Input names double as channel names everywhere:
  # settings, quirks and the resulting pkgs namespaces.
  channelInputs =
    inputs
    |> lib.filterAttrs (name: _: lib.hasPrefix "nixpkgs" name);

  channels = lib.attrNames channelInputs;

  secondaryChannelsFor = entity: lib.filter (channel: channel != entity.defaultChannel) channels;

  mkChannelSet = entity: channel: rawConfig: prev:
    if channel == entity.defaultChannel
    then prev
    else
      import channelInputs.${channel} {
        inherit (prev.stdenv.hostPlatform) system;
        config = rawConfig;
      };

  # Fold per-aspect quirk contributions into one attrset, warning on conflicts.
  collect = packageChannels:
    packageChannels
    |> lib.foldl'
    (
      acc: entry:
        if !(lib.isAttrs entry)
        then acc
        else
          acc
          // lib.mapAttrs (
            pkg: channel:
              if acc ? ${pkg} && acc.${pkg} != channel
              then
                lib.warn
                "Channel conflict for '${pkg}': '${acc.${pkg}}' vs '${channel}'; using '${channel}'."
                channel
              else channel
          )
          entry
    )
    {};

  overlay = entity: packageChannels: rawConfig: _final: prev: let
    declared = packageChannels |> collect;

    # Each secondary channel as a namespace: pkgs.<channel>.<pkg>.
    namespaces =
      lib.genAttrs (secondaryChannelsFor entity) (channel: mkChannelSet entity channel rawConfig prev);

    # Packages explicitly pinned via the quirk, resolved from their channel.
    swaps =
      declared
      |> lib.filterAttrs (_pkg: channel: channel != entity.defaultChannel)
      |> lib.mapAttrs (pkg: channel: (mkChannelSet entity channel rawConfig prev).${pkg});
  in
    namespaces // swaps;
in {
  den.aspects.basic.channel-collector = {
    description = ''
      Collector which assembles package channels: exposes every non-default
      channel as `pkgs.<channel>.<pkg>` (e.g. `pkgs.nixpkgs-stable.<pkg>`, where
      the channel name is the flake input name) and resolves packages pinned via
      the `packageChannels` quirk from their chosen channel.
    '';

    nixos = {
      host,
      packageChannels,
      config,
      ...
    }: let
      usedChannels =
        packageChannels
        |> lib.concatMap (entry:
          if lib.isAttrs entry
          then builtins.attrValues entry
          else [])
        |> lib.unique
        |> lib.filter (channel: !(channelInputs ? ${channel}));
    in {
      nixpkgs.overlays = [
        (overlay host packageChannels config.nixpkgs.config)
      ];

      assertions = lib.optionals (usedChannels != []) [
        {
          assertion = false;
          message = "Unknown channel(s) in packageChannels quirk: ${lib.concatStringsSep ", " usedChannels}. Available channels: ${lib.concatStringsSep ", " channels}.";
        }
      ];
    };
  };

  den.aspects.basic.channel-user-collector = {
    description = ''
      Home Manager collector which applies userPackageChannels to the user's
      private package set, using the host's defaultChannel as its base and
      resolving explicitly pinned packages from their selected input.
    '';

    hm = {
      host,
      userPackageChannels,
      config,
      ...
    }: let
      usedChannels =
        userPackageChannels
        |> lib.concatMap (entry:
          if lib.isAttrs entry
          then builtins.attrValues entry
          else [])
        |> lib.unique
        |> lib.filter (channel: !(channelInputs ? ${channel}));
    in {
      # The host supplies the base package set for each user's Home Manager config.
      nixpkgs.overlays = [
        (overlay host userPackageChannels config.nixpkgs.config)
      ];

      assertions = lib.optionals (usedChannels != []) [
        {
          assertion = false;
          message = "Unknown channel(s) in userPackageChannels quirk: ${lib.concatStringsSep ", " usedChannels}. Available channels: ${lib.concatStringsSep ", " channels}.";
        }
      ];
    };
  };
}
