return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {},
      explorer = {},
    },
    keys = {
      -- Top Pickers & Explorer
      {
        "<leader><space>",
        function()
          Snacks.picker.smart()
        end,
        desc = "Smart Find Files",
      },
    },
  },
}
