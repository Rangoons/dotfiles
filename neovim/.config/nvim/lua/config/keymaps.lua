-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.schedule(function()
  Snacks.toggle({
    name = "Copilot",
    get = function()
      return vim.lsp.inline_completion.is_enabled()
    end,
    set = function(state)
      vim.lsp.inline_completion.enable(state)
    end,
  }):map("<leader>uP")
end)
