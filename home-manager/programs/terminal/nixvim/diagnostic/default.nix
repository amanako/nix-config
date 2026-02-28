{
	programs.nixvim.diagnostic.settings = {
		virtual_text = false;
		virtual_lines.only_current_line = true;
		# For easy-to-spot diagnostics
		plugins.lsp_lines.enable = true;
  };
}
