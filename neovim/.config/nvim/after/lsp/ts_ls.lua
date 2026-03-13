-- This file contains configuration of 'ts_ls' language server.
-- Source: https://github.com/typescript-language-server/typescript-language-server
--
-- It is used by `:h vim.lsp.enable()` and `:h vim.lsp.config()`.
-- See `:h vim.lsp.Config` and `:h vim.lsp.ClientConfig` for all available fields.
return {
	on_attach = function(client, buf_id)
		-- Disable formatting in favor of prettier (via conform.nvim)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
	settings = {
		typescript = {
			preferences = {
				importModuleSpecifier = "relative",
			},
		},
		javascript = {
			preferences = {
				importModuleSpecifier = "relative",
			},
		},
	},
	-- eslint and prettier are handled via conform.nvim (eslint_d + prettierd)
	-- see plugin/plugins.lua conform setup
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
}
