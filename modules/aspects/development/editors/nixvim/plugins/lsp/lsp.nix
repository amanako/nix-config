{
  nixvim.plugins.homeManager.programs.nixvim.plugins = {
    lspkind.enable = true;
    lsp-signature.enable = true;
    lsp-config.enable = true;

    lsp = {
      enable = true;

      servers = {
        nixd.enable = true;
        clangd.enable = true;
        cmake.enable = true;
        html.enable = true;
      };

      keymaps = {
        silent = true;
        lspBuf = {
          "<leader>ca" = {
            action = "code_action";
            desc = "LSP code action";
          };
          "<leader>cr" = {
            action = "rename";
            desc = "LSP rename";
          };
        };
      };
    };
  };
}
