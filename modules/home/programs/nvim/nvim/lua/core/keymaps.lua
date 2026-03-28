local keymap = vim.keymap.set

-- Write file
keymap("n", "<C-s>", ":w<CR>", { desc = "Write file" })

-- Close file
keymap("n", "<C-q>", ":q<CR>", { desc = "Close file" })

-- Write all files
keymap("n", "<leader>w", ":wa<CR>", { desc = "Write all files" })

-- Close all files
keymap("n", "<leader>qq", ":qa!<CR>", { desc = "Close all files" })

-- Format file
keymap("n", "<leader>lf", "<cmd>Format<CR>", { desc = "Format file" })
