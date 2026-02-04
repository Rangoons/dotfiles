-- Helper function: format branch names
local function format_branch(str)
  if str == "" or str == nil then
    return ""
  end
  -- Match project-123 pattern at the start (case insensitive)
  local short = str:match("^(%a+%-%d+)")
  return short or str
end

-- Helper function: weather with caching
local weather_cache = { temp = "", last_update = 0 }
local CACHE_DURATION = 3600 -- 1 hour

local function fetch_weather()
  local current_time = os.time()

  if current_time - weather_cache.last_update < CACHE_DURATION then
    return weather_cache.temp
  end

  vim.fn.jobstart('curl -s "wttr.in/Thompson,PA?u&format=%c+%t"', {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data and data[1] and data[1] ~= "" then
        weather_cache.temp = vim.trim(data[1])
        weather_cache.last_update = current_time
      end
    end,
  })

  return weather_cache.temp ~= "" and weather_cache.temp or "..."
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

      -- Replace clock with weather
      opts.sections.lualine_z = { { fetch_weather, icon = "" } }

      return opts
    end,
  },
}
