local now, now_if_args, later, on_packchanged = Config.now, Config.now_if_args, Config.later, Config.on_packchanged
local add = vim.pack.add
now(function()
	add({ "https://github.com/savq/melange-nvim" })
	vim.cmd("colorscheme melange")
end)
now_if_args(function()
	local ts_update = function()
		vim.cmd("TSUpdate")
	end
	on_packchanged("nvim-treesitter", { "update" }, ts_update, ":TSUpdate")

	add({
		"https://github.com/nvim-treesitter/nvim-treesitter",
		"https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
		"https://github.com/nvim-treesitter/nvim-treesitter-context",
		"https://github.com/JoosepAlviste/nvim-ts-context-commentstring",
		"https://github.com/windwp/nvim-ts-autotag",
	})

	-- Install missing parsers (skips already-installed ones automatically)
	local languages = {
		"vim",
		"vimdoc",
		"go",
		"html",
		"css",
		"javascript",
		"json",
		"lua",
		"markdown",
		"typescript",
		"tsx",
		"bash",
	}
	require("nvim-treesitter").install(languages)

	-- Enable tree-sitter highlighting + indent for target filetypes
	local filetypes = {}
	for _, lang in ipairs(languages) do
		for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
			table.insert(filetypes, ft)
		end
	end
	Config.new_autocmd("FileType", filetypes, function(ev)
		pcall(vim.treesitter.start, ev.buf)
	end, "Start tree-sitter")

	require("treesitter-context").setup({
		max_lines = 3,
		trim_scope = "inner",
	})

	require("ts_context_commentstring").setup({
		enable_autocmd = false,
	})

	require("nvim-ts-autotag").setup({})
end)
later(function()
	add({ "https://github.com/lewis6991/gitsigns.nvim" })
	require("gitsigns").setup({
		signs = {
			add = { text = "\u{2590}" }, -- ▏
			change = { text = "\u{2590}" }, -- ▐
			delete = { text = "\u{2590}" }, -- ◦
			topdelete = { text = "\u{25e6}" }, -- ◦
			changedelete = { text = "\u{25cf}" }, -- ●
			untracked = { text = "\u{25cb}" }, -- ○
		},
		signcolumn = true,
		current_line_blame = false,
	})

	vim.keymap.set("n", "]h", function()
		require("gitsigns").next_hunk()
	end, { desc = "Next git hunk" })
	vim.keymap.set("n", "[h", function()
		require("gitsigns").prev_hunk()
	end, { desc = "Previous git hunk" })
	vim.keymap.set("n", "<leader>ghs", function()
		require("gitsigns").stage_hunk()
	end, { desc = "Stage hunk" })
	vim.keymap.set("n", "<leader>ghr", function()
		require("gitsigns").reset_hunk()
	end, { desc = "Reset hunk" })
	vim.keymap.set("n", "<leader>ghp", function()
		require("gitsigns").preview_hunk()
	end, { desc = "Preview hunk" })
	vim.keymap.set("n", "<leader>gb", function()
		require("gitsigns").blame_line({ full = true })
	end, { desc = "Blame line" })
	vim.keymap.set("n", "<leader>gB", function()
		require("gitsigns").toggle_current_line_blame()
	end, { desc = "Toggle inline blame" })
	vim.keymap.set("n", "<leader>ghd", function()
		require("gitsigns").diffthis()
	end, { desc = "Diff this" })
end)
-- LSP ===================================================================
now_if_args(function()
	add({ "https://github.com/neovim/nvim-lspconfig" })

	vim.lsp.enable({
		"lua_ls",
		"bashls",
		"ts_ls",
		"gopls",
		"eslint",
	})
end)
now_if_args(function()
	add({ "https://github.com/mason-org/mason.nvim" })
	require("mason").setup()
end)
local diagnostic_signs = {
	-- Error = " ",
	-- Warn = " ",
	-- Hint = "",
	-- Info = "",
	Error = "⛔",
	Warn = "⚠️",
	Hint = "💡",
	Info = "☝️",
}

vim.diagnostic.config({
	virtual_text = { prefix = "●", spacing = 4 },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
			[vim.diagnostic.severity.WARN] = diagnostic_signs.Warn,
			[vim.diagnostic.severity.INFO] = diagnostic_signs.Info,
			[vim.diagnostic.severity.HINT] = diagnostic_signs.Hint,
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
		focusable = false,
		style = "minimal",
	},
})

do
	local orig = vim.lsp.util.open_floating_preview
	function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
		opts = opts or {}
		opts.border = opts.border or "rounded"
		return orig(contents, syntax, opts, ...)
	end
end

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)

		local nmap = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc })
		end

		nmap("gd", vim.lsp.buf.definition, "Go to definition")
		nmap("g.", vim.lsp.buf.code_action, "Code actions")
		nmap("gk", vim.lsp.buf.signature_help, "Signature Help")
		nmap("g=", vim.lsp.buf.format, "Format code")

		nmap("K", vim.lsp.buf.hover, "Show diagnostic or LSP hover")
	end,
})
later(function()
	add({ "https://github.com/stevearc/conform.nvim" })

	require("conform").setup({
		default_format_opts = {
			timeout_ms = 3000,
			lsp_format = "fallback",
		},
		format_on_save = {
			lsp_format = "fallback",
			-- timeout_ms = 500,
		},
		formatters_by_ft = {
			javascript = { "eslint_d", "prettierd" },
			javascriptreact = { "eslint_d", "prettierd" },
			typescript = { "eslint_d", "prettierd" },
			typescriptreact = { "eslint_d", "prettierd" },
			css = { "prettierd" },
			html = { "prettierd" },
			json = { "prettierd" },
			jsonc = { "prettierd" },
			markdown = { "prettierd" },
			lua = { "stylua" },
			go = { "gofumpt" },
			sh = { "shfmt" },
		},
	})

	-- vim.api.nvim_create_autocmd("BufWritePre", {
	-- 	group = vim.api.nvim_create_augroup("format-on-save", { clear = true }),
	-- 	callback = function(ev)
	-- 		require("conform").format({ bufnr = ev.buf, timeout_ms = 3000, lsp_format = "never", quiet = true })
	-- 	end,
	-- })
end)
later(function()
	add({ "https://github.com/saghen/blink.cmp" })
	require("blink.cmp").setup({
		keymap = {
			preset = "none",
			["<C-Space>"] = { "show", "hide" },
			["<C-y>"] = { "accept", "fallback" },
			["<C-n>"] = { "select_next", "fallback" },
			["<C-p>"] = { "select_prev", "fallback" },
		},
		appearance = { nerd_font_variant = "mono" },
		completion = { menu = { auto_show = true } },
		sources = { default = { "lsp", "path", "buffer", "snippets" } },
		fuzzy = {
			implementation = "prefer_rust",
			prebuilt_binaries = { download = true },
		},
	})

	vim.lsp.config["*"] = {
		capabilities = require("blink.cmp").get_lsp_capabilities(),
	}
end)

vim.lsp.config("bashls", {})
vim.lsp.config("ts_ls", {})
vim.lsp.config("gopls", {})
vim.lsp.config("eslint", {})
later(function()
	add({ "https://github.com/folke/snacks.nvim" })
	require("snacks").setup({
		indent = { enabled = true },
		image = { enabled = true },
		rename = { enabled = true },
		bufdelete = { enabled = true },
	})
	local Snacks = require("snacks")
	vim.keymap.set("n", "<Leader>bd", Snacks.bufdelete.delete, { desc = "Delete Buffer" })
	vim.keymap.set("n", "<Leader>bo", Snacks.bufdelete.other, { desc = "Delete Other Buffers" })
	vim.api.nvim_create_autocmd("User", {
		pattern = "MiniFilesActionRename",
		callback = function(event)
			Snacks.rename.on_rename_file(event.data.from, event.data.to)
		end,
	})
end)
local function nmap(key, action, description)
	vim.keymap.set("n", key, action, { desc = description })
end
later(function()
	add({
		{ src = "https://github.com/ThePrimeagen/harpoon", branch = "harpoon2" },
		"https://github.com/nvim-lua/plenary.nvim",
	})
	local harpoon = require("harpoon")
	harpoon:setup({
		settings = {
			save_on_toggle = true,
		},
	})
	nmap("<leader>a", function()
		harpoon:list():add()
	end, "Harpoon file")
	nmap("<C-e>", function()
		harpoon.ui:toggle_quick_menu(harpoon:list())
	end, "Harpoon Quick Menu")
	for i = 1, 4 do
		nmap("<leader>" .. i, function()
			harpoon:list():select(i)
		end, "Harpoon to file " .. i)
	end
end)
