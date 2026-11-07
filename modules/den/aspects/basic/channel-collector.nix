{
  lib,
  inputs,
  ...
}: let
  # Friendly channel name (as used in settings and the quirk) -> flake input name.
  toFriendly = name:
    if name == "nixpkgs"
    then "pkgs"
    else lib.removePrefix "nixpkgs-" name;

  channelInputs =
    inputs
    |> lib.filterAttrs (name: _: lib.hasPrefix "nixpkgs" name)
    |> lib.mapAttrs' (name: _: {
      name = toFriendly name;
      value = name;
    });

  channels = lib.attrNames channelInputs;

  secondaryChannelsFor = entity: lib.filter (channel: channel != entity.defaultChannel) channels;

  # Accept either a friendly channel name ("stable") or a full input name
  # ("nixpkgs-stable"), mirroring what the host defaultChannel option allows.
  normalize = channel:
    if lib.hasPrefix "nixpkgs" channel
    then toFriendly channel
    else channel;

  mkChannelSet = entity: channel: rawConfig: prev:
    if channel == entity.defaultChannel
    then prev
    else
      import inputs.${channelInputs.${channel}} {
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

    # Each non-root channel as a namespace: pkgs.chan.<channel>.<pkg>.
    namespaces =
      lib.genAttrs (secondaryChannelsFor entity) (channel: mkChannelSet entity channel rawConfig prev);

    # Packages explicitly pinned via the quirk, resolved from their channel.
    swaps =
      declared
      |> lib.filterAttrs (_pkg: channel: channel != entity.defaultChannel)
      |> lib.mapAttrs (pkg: channel: (mkChannelSet entity channel rawConfig prev).${pkg});
  in
in {
  den.aspects.basic.channel-collector = {
    description = ''
      Collector which assembles package channels: exposes every non-root channel as
      `pkgs.chan.<channel>.<pkg>` and resolves packages pinned via the
      `packageChannels` quirk from their chosen channel.
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
        |> lib.map normalize
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
      Home Manager collector which applies userPackageChannels contributions to
      the user's package set, including packages pinned to a non-default channel.
    '';

    hm = {
      user,
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
        |> lib.map normalize
        |> lib.unique
        |> lib.filter (channel: !(channelInputs ? ${channel}));
    in {
      nixpkgs.overlays = [
        (overlay user userPackageChannels config.nixpkgs.config)
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
