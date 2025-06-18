-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.o.background = "dark"
vim.opt.termguicolors = true
vim.cmd.hi("Comment gui=none")

if require("utils").is_dark_mode() then
  vim.cmd("colorscheme rose-pine-main")
else
  vim.o.background = "light"
  vim.cmd("colorscheme rose-pine-dawn")
end
-------------------
-- Custom Macros --
-------------------
local esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)
vim.fn.setreg("l", "yoconsole.log('" .. esc .. "pa:" .. esc .. "la, " .. esc .. "pl")
