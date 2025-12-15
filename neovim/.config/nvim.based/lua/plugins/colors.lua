return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000, -- Make sure to load this before all the other start plugins.
  },
  {
    'rose-pine/neovim',
    lazy = false,
    priority = 1000,
  },
  {
    'rebelot/kanagawa.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = 'none',
            },
          },
        },
      },
    },
  },
}
