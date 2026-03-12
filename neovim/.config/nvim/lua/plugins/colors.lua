return {
	{
		"rose-pine/neovim",
		lazy = false,
		priority = 1000,
	},
	{
		"savq/melange-nvim",
	},
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			colors = {
				theme = {
					all = {
						ui = {
							bg_gutter = "none",
						},
					},
				},
			},
		},
	},
}
