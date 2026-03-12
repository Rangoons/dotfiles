return {
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function()
      require("tiny-inline-diagnostic").setup({
        preset = "classic",
        signs = {
          left = "", -- Left border character
          right = "", -- Right border character
          diag = "●", -- Diagnostic indicator character
          arrow = "", -- Arrow pointing to diagnostic
          up_arrow = "", -- Upward arrow for multiline
          vertical = " │", -- Vertical line for multiline
          vertical_end = " └", -- End of vertical line for multiline
        },
        blend = {
          factor = 0.08, -- Transparency factor (0.0 = transparent, 1.0 = opaque)
        },
      })
      vim.diagnostic.config({ virtual_text = false }) -- Disable default virtual text
    end,
  },
  {
    "dmmulroy/ts-error-translator.nvim",
    config = function()
      require("ts-error-translator").setup()
    end,
  },
}
