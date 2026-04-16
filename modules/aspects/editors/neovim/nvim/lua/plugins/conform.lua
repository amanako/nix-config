return {
	"stevearc/conform.nvim",
	event = { "BufWritePre", "BufReadPost" },
	keys = {
		{
			"cf",
			function()
				require("conform").format({
					range = {
						start = vim.api.nvim_buf_get_mark(0, "<"),
						["end"] = vim.api.nvim_buf_get_mark(0, ">"),
					},
				})
			end,
			mode = "v",
			desc = "Format selection",
		},
		{
			"cF",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "n",
			desc = "Format buffer",
		},
	},
	opts = {
		formatters_by_ft = {
			cpp = { 'clang-format' },
			css = { "prettier" },
			html = { "prettier" },
			json = { "prettier" },
			jsonc = { "prettier" },
			lua = { "stylua" },
			markdown = { "prettier" },
			nix = { "nixfmt" },
			["*"] = { "trim_whitespace" },
		},
	},
	config = function()
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function(args)
				require("conform").format({ bufnr = args.buf })
			end,
		})
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
