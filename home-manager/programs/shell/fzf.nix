{
  programs.fzf = {
    enable = true;
    # Enables the following
    # <C-t> = fzf select
    # <C-r> = fzf history
    # Alt-c = fzf cd
    enableFishIntegration = true;
    defaultOptions = [
      "--border"
    ];
  };
}
