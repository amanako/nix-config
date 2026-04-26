return {
  'mfussenegger/nvim-lint',
  config = function()
    require('lint').linters_by_ft = {
      bash = { 'bash' },
      cpp = { 'clangtidy' },
      cmake = { 'cmake_lint' },
      fish = { 'fish' },
      html = { 'tidy' },
      json = { 'json' },
      lua = { 'luacheck' },
      nix = { 'nix' },
      markdown = { 'markdownlint' },
      rs = { 'rstcheck', 'rstlint' },
    }
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
