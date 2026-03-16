local now, now_if_args, later = Config.now, Config.now_if_args, Config.later
now(function()
	require("mini.basics").setup({
		-- Manage options in 'plugin/10_options.lua' for didactic purposes
		options = { basic = false },
		mappings = {
			-- Create `<C-hjkl>` mappings for window navigation
			windows = true,
			-- Create `<M-hjkl>` mappings for navigation in Insert and Command modes
			move_with_alt = true,
		},
	})
end)
now(function()
	-- Set up to not prefer extension-based icon for some extensions
	local ext3_blocklist = { scm = true, txt = true, yml = true }
	local ext4_blocklist = { json = true, yaml = true }
	require("mini.icons").setup({
		use_file_extension = function(ext, _)
			return not (ext3_blocklist[ext:sub(-3)] or ext4_blocklist[ext:sub(-4)])
		end,
	})

	-- Not needed for 'mini.nvim' but might be useful for others.
	later(MiniIcons.mock_nvim_web_devicons)

	-- Add LSP kind icons. Useful for 'mini.completion'.
	later(MiniIcons.tweak_lsp_kind)
end)
now(function()
	require("mini.notify").setup()
end)

-- - `<Leader>sn` - start new session
-- - `<Leader>sr` - read previously started session
-- - `<Leader>sd` - delete previously started session
now(function()
	require("mini.sessions").setup()
end)

now(function()
	local linear_output = ""
	local starter = require("mini.starter")
	local footer_fn = function()
		return linear_output
	end
	starter.setup({
		footer = footer_fn,
	})
	vim.fn.jobstart("quick-branch list", {
		stdout_buffered = true,
		on_stdout = function(_, data)
			local output = vim.trim(table.concat(data, "\n"))
			if output ~= "" then
				linear_output = output
			end
			vim.schedule(function()
				pcall(starter.refresh)
			end)
		end,
	})
end)
now(function()
	local function format_branch(str)
		if str == "" or str == nil then
			return ""
		end
		-- Match project-123 pattern at the start (case insensitive)
		local short = str:match("^(%a+%-%d+)")
		return short or str
	end
	local statusline = require("mini.statusline")
	statusline.setup({ use_icons = vim.g.have_nerd_font })

	statusline.section_fileinfo = function()
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
end)

now_if_args(function()
	-- Enable directory/file preview
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
	-- Add common bookmarks for every explorer. Example usage inside explorer:
	-- - `'c` to navigate into your config directory
	-- - `g?` to see available bookmarks
	local add_marks = function()
		MiniFiles.set_bookmark("c", vim.fn.stdpath("config"), { desc = "Config" })
		local vimpack_plugins = vim.fn.stdpath("data") .. "/site/pack/core/opt"
		MiniFiles.set_bookmark("p", vimpack_plugins, { desc = "Plugins" })
		MiniFiles.set_bookmark("w", vim.fn.getcwd, { desc = "Working directory" })
	end
	Config.new_autocmd("User", "MiniFilesExplorerOpen", add_marks, "Add bookmarks")
end)

vim.keymap.set("n", "-", function()
	local buf_name = vim.api.nvim_buf_get_name(0)
	local path = vim.fn.filereadable(buf_name) == 1 and buf_name or vim.fn.getcwd()
	require("mini.files").open(path)
end, { desc = "Open file explorer" })

later(function()
	require("mini.extra").setup()
end)

now_if_args(function()
	later(function()
		local ai = require("mini.ai")
		ai.setup({
			n_lines = 500,
			custom_textobjects = {
				o = ai.gen_spec.treesitter({ -- code block
					a = { "@block.outer", "@conditional.outer", "@loop.outer" },
					i = { "@block.inner", "@conditional.inner", "@loop.inner" },
				}),
				f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
				c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
				t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
				d = { "%f[%d]%d+" }, -- digits
				e = { -- Word with case
					{ "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
					"^().*()$",
				},
				g = MiniExtra.gen_ai_spec.buffer(), -- buffer
				u = ai.gen_spec.function_call(), -- u for "Usage"
				U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
			},
			-- custom_textobjects = {
			-- 	-- Make `aB` / `iB` act on around/inside whole *b*uffer
			-- 	B = MiniExtra.gen_ai_spec.buffer(),
			-- 	-- For more complicated textobjects that require structural awareness,
			-- 	-- use tree-sitter. This example makes `aF`/`iF` mean around/inside function
			-- 	-- definition (not call). See `:h MiniAi.gen_spec.treesitter()` for details.
			-- 	F = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
			-- },
			--
			-- -- 'mini.ai' by default mostly mimics built-in search behavior: first try
			-- -- to find textobject covering cursor, then try to find to the right.
			-- -- Although this works in most cases, some are confusing. It is more robust to
			-- -- always try to search only covering textobject and explicitly ask to search
			-- -- for next (`an`/`in`) or last (`al`/`il`).
			-- -- Try this. If you don't like it - delete next line and this comment.
			-- search_method = "cover",
		})
	end)
end)
now_if_args(function()
	require("mini.misc").setup()
	-- MiniMisc.setup_auto_root()
	MiniMisc.setup_restore_cursor()
	MiniMisc.setup_termbg_sync()
end)

later(function()
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
			prompt_caret = "🫷",
			prompt_prefix = "😈",
		},
	})
end)
later(function()
	require("mini.pairs").setup({
		modes = { insert = true, command = true, terminal = false },
		-- skip autopair when next character is one of these
		skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
		-- skip autopair when the cursor is inside these treesitter nodes
		skip_ts = { "string" },
		-- skip autopair when next character is closing pair
		-- and there are more closing pairs than opening pairs
		skip_unbalanced = true,
		-- better deal with markdown code blocks
		markdown = true,
	})
end)

later(function()
	local miniclue = require("mini.clue")
  -- stylua: ignore
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
    -- Explicitly opt-in for set of common keys to trigger clue window
    triggers = {
      { mode = { 'n', 'x' }, keys = '<Leader>' }, -- Leader triggers
      { mode =   'n',        keys = '\\' },       -- mini.basics
      { mode = { 'n', 'x' }, keys = '[' },        -- mini.bracketed
      { mode = { 'n', 'x' }, keys = ']' },
      { mode =   'i',        keys = '<C-x>' },    -- Built-in completion
      { mode = { 'n', 'x' }, keys = 'g' },        -- `g` key
      { mode = { 'n', 'x' }, keys = "'" },        -- Marks
      { mode = { 'n', 'x' }, keys = '`' },
      { mode = { 'n', 'x' }, keys = '"' },        -- Registers
      { mode = { 'i', 'c' }, keys = '<C-r>' },
      { mode =   'n',        keys = '<C-w>' },    -- Window commands
      { mode = { 'n', 'x' }, keys = 's' },        -- `s` key (mini.surround, etc.)
      { mode = { 'n', 'x' }, keys = 'z' },        -- `z` key
    },
      window = {
        config = {
          width = 'auto',
        },
        delay = 500,
        scroll_down = '<C-d>',
        scroll_up = '<C-u>',
      },
  })
end)

later(function()
	require("mini.cmdline").setup()
end)

later(function()
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
end)
-- stylua: ignore end
