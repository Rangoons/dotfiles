-- Helper function: format branch names
local function format_branch(str)
  if str == "" or str == nil then
    return ""
  end
  -- Match project-123 pattern at the start (case insensitive)
  local short = str:match("^(%a+%-%d+)")
  return short or str
end

-- Plugin spec
return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      local icons = LazyVim.config.icons

      -- Replace branch component in lualine_b with formatted version
      opts.sections.lualine_b = {
        {
          "branch",
          icon = "",
          fmt = format_branch,
        },
      }

      -- Rebuild lualine_c with full relative path
      opts.sections.lualine_c = {
        LazyVim.lualine.root_dir(),
        {
          "diagnostics",
          symbols = {
            error = icons.diagnostics.Error,
            warn = icons.diagnostics.Warn,
            info = icons.diagnostics.Info,
            hint = icons.diagnostics.Hint,
          },
        },
        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        {
          LazyVim.lualine.pretty_path(),
        },
      }

      -- Clear position indicators
      opts.sections.lualine_y = {}


      return opts
    end,
  },
}
