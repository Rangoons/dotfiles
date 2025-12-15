local function nmap(key, action, description)
  vim.keymap.set('n', key, action, { desc = description })
end
return {
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'
      harpoon:setup()
      nmap('<leader>a', function()
        harpoon:list():add()
      end, 'Harpoon file')
      nmap('<C-e>', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, 'Harpoon Quick Menu')
      for i = 1, 4 do
        nmap('<leader>' .. i, function()
          harpoon:list():select(i)
        end, 'Harpoon to file ' .. i)
      end
    end,
  },
}
