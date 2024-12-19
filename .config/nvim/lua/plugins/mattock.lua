return {
  {
    "rangoons/mattock",
    event = "VeryLazy", -- Or `LspAttach`
    config = function()
      require("mattock").setup()
    end,
  },
}
