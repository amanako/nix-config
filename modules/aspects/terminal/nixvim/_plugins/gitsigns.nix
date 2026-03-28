{
  plugins.gitsigns = {
    enable = true;
    settings = {
      signs = {
        add.text = "┃";
        change.text = "┃";
        delete.text = "▁";
        topdelete.text = "▔";
        changedelete.text = "~";
        untracked.text = "┆";
      };

      current_line_blame = true;
      current_line_blame_opts = {
        virt_text = true;
        virt_text_pos = "eol";
        delay = 1000;
      };

      # Attachment behavior
      auto_attach = true;
      attach_to_untracked = true;
      update_debounce = 100;
    };
  };
}
