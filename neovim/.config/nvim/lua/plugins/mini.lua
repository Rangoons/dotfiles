local function format_branch(str)
	if str == "" or str == nil then
		return ""
	end
	-- Match project-123 pattern at the start (case insensitive)
	local short = str:match("^(%a+%-%d+)")
	return short or str
end

return {
	{
		"nvim-mini/mini.nvim",
		config = function()
			-- MINI config ==================================================================
			require("mini.basics").setup({
				options = { basic = true },
				mappings = {
					windows = true,
					move_with_alt = true,
				},
			})
			vim.opt.listchars:append({ tab = "  " })
			require("mini.surround").setup()
			require("mini.ai").setup({ n_lines = 500 })
			require("mini.notify").setup({
				lsp_progress = {
					enable = false,
					level = "ERROR",
				},
			})
			require("mini.sessions").setup()
			require("mini.starter").setup()
			require("mini.extra").setup()
			require("mini.bracketed").setup()
			require("mini.bufremove").setup()
			local miniclue = require("mini.clue")
			miniclue.setup({
				clues = {
					Config.leader_group_clues,
					miniclue.gen_clues.builtin_completion(),
					miniclue.gen_clues.g(),
					miniclue.gen_clues.marks(),
					miniclue.gen_clues.registers(),
					miniclue.gen_clues.square_brackets(),
					miniclue.gen_clues.windows({ submode_resize = true }),
					miniclue.gen_clues.z(),
				},
				triggers = {
					{ mode = { "n", "x" }, keys = "<Leader>" }, -- Leader triggers
					{ mode = "n", keys = "\\" }, -- mini.basics
					{ mode = { "n", "x" }, keys = "[" }, -- mini.bracketed
					{ mode = { "n", "x" }, keys = "]" },
					{ mode = "i", keys = "<C-x>" }, -- Built-in completion
					{ mode = { "n", "x" }, keys = "g" }, -- `g` key
					{ mode = { "n", "x" }, keys = "'" }, -- Marks
					{ mode = { "n", "x" }, keys = "`" },
					{ mode = { "n", "x" }, keys = '"' }, -- Registers
					{ mode = { "i", "c" }, keys = "<C-r>" },
					{ mode = "n", keys = "<C-w>" }, -- Window commands
					{ mode = { "n", "x" }, keys = "s" }, -- `s` key (mini.surround, etc.)
					{ mode = { "n", "x" }, keys = "z" }, -- `z` key
				},
				window = {
					delay = 0,
					config = {
						width = "auto",
					},
					scroll_down = "<C-d>",
					scroll_up = "<C-u>",
				},
			})
			require("mini.comment").setup({
				options = {
					ignore_blank_line = true,
					custom_commentstring = function()
						return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
					end,
				},
			})
			require("mini.diff").setup()
			require("mini.files").setup({
				mappings = {
					go_in = "",
					go_in_plus = "l",
				},
				windows = {
					preview = false,
					max_number = 2,
					width_focus = 30,
					width_nofocus = 30,
					width_preview = 80,
				},
			})
			vim.keymap.set("n", "-", function()
				local buf_name = vim.api.nvim_buf_get_name(0)
				local path = vim.fn.filereadable(buf_name) == 1 and buf_name or vim.fn.getcwd()
				require("mini.files").open(path)
			end, { desc = "Open file explorer" })
			require("mini.git").setup()
			local hipatterns = require("mini.hipatterns")
			local hi_words = MiniExtra.gen_highlighter.words
			hipatterns.setup({
				highlighters = {
					-- Highlight a fixed set of common words. Will be highlighted in any place,
					-- not like "only in comments".
					fixme = hi_words({ "FIXME", "Fixme", "fixme" }, "MiniHipatternsFixme"),
					hack = hi_words({ "HACK", "Hack", "hack" }, "MiniHipatternsHack"),
					todo = hi_words({ "TODO", "Todo", "todo" }, "MiniHipatternsTodo"),
					note = hi_words({ "NOTE", "Note", "note" }, "MiniHipatternsNote"),

					-- Highlight hex color string (#aabbcc) with that color as a background
					hex_color = hipatterns.gen_highlighter.hex_color(),
				},
			})
			require("mini.pairs").setup()
			require("mini.pick").setup({
				mappings = {
					delete_left = "<A-BS>",
					scroll_up = "<C-u>",
					scroll_down = "<C-d>",
					scroll_left = "<C-h>",
					scroll_right = "<C-l>",
				},
				window = {
					config = {
						style = "minimal",
						border = "rounded",
					},
					-- String to use as cursor in prompt
					prompt_caret = "🫷",

					-- String to use as prefix in prompt
					prompt_prefix = "😈",
				},
			})

			local statusline = require("mini.statusline")
			statusline.setup({ use_icons = vim.g.have_nerd_font })

			statusline.section_fileinfo = function(args)
				return ""
			end
			statusline.section_diff = function()
				return ""
			end
			statusline.section_git = function()
				local summary = vim.b.minigit_summary_string
				if summary == nil then
					return ""
				end
				return format_branch(summary)
			end
			statusline.section_location = function(args)
				local summary = vim.b.minidiff_summary_string or vim.b.gitsigns_status
				if summary == nil then
					return ""
				end
				local icon = args.icon or (true and "" or "Diff")
				return icon .. " " .. (summary == "" and "-" or summary)
			end
			require("mini.icons").setup()
			require("mini.icons").mock_nvim_web_devicons()
			require("mini.icons").tweak_lsp_kind()
		end,
	},
}
