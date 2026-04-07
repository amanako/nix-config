return {
  'ibhagwan/fzf-lua',
  -- optional for icon support
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  -- dependencies = { 'nvim-mini/mini.icons' },
  ---@module 'fzf-lua'
  ---@type fzf-lua.Config|{}
  ---@diagnostic disable: missing-fields
  config = function()
    -- Grab global index
    require('fzf-lua').setup {
      winopts = {
        height = 0.9,
	width = 0.8,
	border = 'rounded',
	backdrop = 95,
        preview = {
          default = 'bat',
	  border = 'rounded',
	  wrap = false,
        },
        winopts = {                       -- builtin previewer window options
        number            = true,
        relativenumber    = true,
        cursorline        = true,
        cursorlineopt     = "both",
        cursorcolumn      = true,
        signcolumn        = "yes",
        list              = false,
        foldenable        = false,
        foldmethod        = "manual",
      },
      },
    }

    local keymap = vim.keymap.set
    keymap('n', '<C-p>', '<cmd>lua FzfLua.files()<CR>', { desc = 'Search files' })
    keymap('n', '<C-g>', '<cmd>lua FzfLua.grep()<CR>', { desc = 'Grep files' })
    keymap('n', '<leader>g', '<cmd>lua FzfLua.global()<CR>', { desc = 'Search globaly' })
    keymap('n', '<C-l>', '<cmd>lua FzfLua.live_grep()<CR>', { desc = 'Live grep' })
    keymap('n', '<C-k>', '<cmd>lua FzfLua.builtin()<CR>', { desc = 'Search builtin commands' })
    keymap('n', '<C-r>', '<cmd>lua FzfLua.resume()<CR>', { desc = 'Resume search' })
    -- To align with yazi
    keymap('n', 'Z', '<cmd>lua FzfLua.zoxide()<CR>', { desc = 'Open zoxide' })
  end,
  ---@diagnostic enable: missing-fields
}
