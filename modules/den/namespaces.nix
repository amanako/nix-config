{
  inputs,
  den,
  ...
}: {
  imports = [(inputs.den.namespace "zen-browser" true)];
  _module.args.__findFile = den.lib.__findFile;
}
