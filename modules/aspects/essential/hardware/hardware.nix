{
  __findFile,
  lib,
  ...
}: {
  den.aspects.hardware = {host}: {
    includes =
      [
        <hardware/audio>
        <hardware/network>
        <hardware/bluetooth>
      ]
      ++ lib.optionals
      host.wantsNvidiaSupport [
        <hardware/graphics/nvidia>
      ];
  };
}
