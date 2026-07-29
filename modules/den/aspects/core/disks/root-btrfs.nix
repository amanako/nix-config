{
  den.aspects.core.disks.root-btrfs = {
    description = ''
      Btrfs root partition. Subvolumes are contributed by other aspects
      via the diskoConfig quirk and injected by the collector.
    '';

    diskoConfig.partitions.root = {
      size = "100%";
      content = {
        type = "btrfs";
        extraArgs = [
          "-f"
        ];
      };
    };
  };
}
