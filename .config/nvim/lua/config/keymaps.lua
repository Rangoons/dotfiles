-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
-- map("n", "<c-P>", require("fzf-lua").files, { desc = "Fzf Files" })
-- prefer gitsigns over snacks/git
-- map("n", "<leader>gb", require("gitsigns").blame_line, { desc = "GitSigns blame line" })
map("n", "<leader>gt", require("gitsigns").toggle_current_line_blame, { desc = "GitSigns toggle signs" })
