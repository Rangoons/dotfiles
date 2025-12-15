return {
  {
    'ahkohd/buffer-sticks.nvim',
    event = 'VeryLazy',
    keys = {
      {
        '<leader>bj',
        function()
          BufferSticks.jump()
        end,
        desc = 'Jump to buffer',
      },
      {
        '<leader>bq',
        function()
          BufferSticks.close()
        end,
        desc = 'Close buffer',
      },
    },

    config = function()
      local sticks = require 'buffer-sticks'
      sticks.setup {
        filter = { buftypes = { 'terminal' } },
        highlights = {
          active = { link = 'Statement' },
          alternate = { link = 'StorageClass' },
          inactive = { link = 'Whitespace' },
          active_modified = { link = 'Constant' },
          alternate_modified = { link = 'Constant' },
          inactive_modified = { link = 'Constant' },
          label = { link = 'Comment' },
          filter_selected = { link = 'Statement' },
          filter_title = { link = 'Comment' },
        },
      }
      sticks.show()
    end,
  },
}
