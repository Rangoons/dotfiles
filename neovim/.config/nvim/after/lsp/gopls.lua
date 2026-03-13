-- This file contains configuration of 'gopls' language server.
-- Source: https://github.com/golang/tools/tree/master/gopls
--
-- It is used by `:h vim.lsp.enable()` and `:h vim.lsp.config()`.
-- See `:h vim.lsp.Config` and `:h vim.lsp.ClientConfig` for all available fields.
return {
	on_attach = function(client, _buf_id)
		-- Disable formatting in favor of gofumpt (via conform.nvim)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
				shadow = true,
			},
			staticcheck = true,
			gofumpt = false, -- handled by conform.nvim
		},
	},
}
