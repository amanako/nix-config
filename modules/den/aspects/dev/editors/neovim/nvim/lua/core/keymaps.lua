local keymap = vim.keymap.set

-- Write file
keymap("n", "<C-s>", "<cmd>w<CR>", { desc = "Write file" })

-- Close file
keymap("n", "<C-q>", "<cmd>q<CR>", { desc = "Close file" })

-- Write all files
keymap("n", "<leader>w", "<cmd>wa<CR>", { desc = "Write all files" })

-- Close all files
keymap("n", "<leader>qq", "<cmd>qa!<CR>", { desc = "Close all files" })

-- Format file
keymap("n", "<leader>lf", "<cmd>Format<CR>", { desc = "Format file" })
