{
  nixvim.plugins.lsp-lines = {
    hm.programs.nixvim = {
      plugins.lsp-lines.enable = true;

      diagnostic.settings = {
        # Disable redundant option
        virtual_text = false;

        virtual_lines = {
          only_current_line = false;
          highlight_whole_line = false;
        };
      };
    };
  };
}
