return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-context",
			"nvim-treesitter/nvim-treesitter-textobjects",
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").setup({
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
			})

			require("treesitter-context").setup({
				enable = false,
			})

			require("ts_context_commentstring").setup({
				enable_autocmd = false,
			})
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		event = { "BufReadPre", "BufNewFile" },
		opts = {},
	},
}
-- vim: ts=2 sts=2 sw=2 et
