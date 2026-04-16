return {
  "mason-org/mason-lspconfig.nvim",
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "neovim/nvim-lspconfig",
  },
  opts = {
    automatic_enable = true,
    ensure_installed = {
      "lua_ls",
      "rust_analyzer",
      "ts_query_ls",
      "clangd",
      -- "fish_lsp",
      "glsl_analyzer",
      "systemd_lsp",
      -- "cmake",
      -- "cssls",
      -- "html",
      -- "jsonls",
      -- "yamlls",
      -- "vimls",
      "qmlls",
    },
  },
}
