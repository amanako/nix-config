return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require('nvim-treesitter').setup {
      highlight = { enable = true },
      install_dir = vim.fn.stdpath('data') .. '/site',
      incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = "gnn",
              node_incremental = "grn",
              scope_incremental = "grc",
              node_decremental = "grm",
            },
          },
          textobjects = {
            select = {
              enable = true,
              lookahead = true,
              keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
              },
            },
          },
         }
  require('nvim-treesitter').install {
      'bash',
      'c',
      'c_sharp',
      'cmake',
      'cpp',
      'css',
      'go',
      'html',
      'java',
      'javascript',
      'json',
      'kdl',
      'kitty',
      'lua',
      'luadoc',
      'make',
      'markdown',
      'ninja',
      'python',
      'regex',
      'rust',
      'sql',
      'tmux',
      'toml',
      'typescript',
      'vim',
      'vimdoc',
      'xml',
      'yaml',
    }
    -- vim.api.nvim_create_autocmd('FileType', {
    --  pattern = ensure_installed,
    --  callback = function(_)
    --	vim.treesitter.start()
    --  end,
    -- })
    -- vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    -- vim.wo[0][0].foldmethod = 'expr'
  end,
}
