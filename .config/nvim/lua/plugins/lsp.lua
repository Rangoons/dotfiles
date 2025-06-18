return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      diagnostics = { virtual_text = false },
      servers = {
        eslint = {
          settings = {
            codeActionOnSave = {
              enable = true,
              mode = "all",
            },
            format = true,
          },
        },
      },
    },
  },
}
