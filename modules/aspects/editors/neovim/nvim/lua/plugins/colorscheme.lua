return { 
  'ellisonleao/gruvbox.nvim',
  priority = 1000,
  lazy = false,
  config = function()
    require('gruvbox').setup {
      italic = {
        strings = true,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
      },
      contrast = 'soft',
      dim_inactive = true,
      transparent_mode = true,
    }
    vim.cmd('colorscheme gruvbox')
  end,
}
