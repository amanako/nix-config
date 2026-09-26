{
  den.aspects.dev.terminal.yazi.plugins.piper = {
    description = "Yazi plugin for custom previewing of various file types.";

    hm = {
      pkgs,
      lib,
      ...
    }: {
      programs.yazi = {
        plugins.piper.package = pkgs.yaziPlugins.piper;

        # I don't suggest using url = "*" since yazi's native previewers can be quite useful
        # (especially for native pdfs previews where overriding * will lose this advantage)
        settings.plugin.prepend_previewers = [
          {
            url = "*.db";
            run = ''piper -- ${lib.getExe pkgs.sqlite} "$1" ".schema --indent"'';
          }
          {
            url = "*.tar*";
            run = ''piper --format=url -- ${lib.getExe pkgs.gnutar} tf "$1"'';
          }
          {
            url = "*.md";
            run = ''piper -- CLICOLOR_FORCE=1 ${lib.getExe pkgs.glow} -s=$t --width=$w "$1"'';
          }
          {
            url = "*/";
            run = ''
              piper -- ${lib.getExe pkgs.eza} -TL=3 --color=always \
              --icons=always --group-directories-first --no-quotes "$1"
            '';
          }
          {
            # Select a theme explicitly to avoid environment variables errors (when other theme like gruvbox is set).
            url = "*.{txt,nix,py,js,ts,go,rs,c,cpp,h,java,rb,sh,zsh,bash,lua,toml,yaml,yml,json,xml,html,css,scss,sql,conf,cfg,ini,env,lock}";
            run = ''
              piper -- ${lib.getExe pkgs.bat} -p --color=always \
              --theme=ansi --decorations=always --no-paging --terminal-width=$w "$1"
            '';
          }
        ];
      };
    };
  };
}
