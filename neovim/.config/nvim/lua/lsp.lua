vim.diagnostic.config({
	update_in_insert = true,
	virtual_text = true,
})

vim.lsp.enable({
	-- npm
	"cssls",
	"html",
	"jsonls",
	"tailwindcss",
	-- eslint configured in lspconfig.lua
	-- vtsls configured in lspconfig.lua
	-- gopls configured in lspconfig.lua
	-- lua_ls configured in lspconfig.lua
	-- gem
	"ruby_lsp",
	"rubocop",
	-- rustup component
	"rust_analyzer",
	-- system
	"sourcekit",
})
