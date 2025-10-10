local M = {}

M.is_dark_mode = function()
  local handle =
    io.popen("osascript -e 'tell application \"System Events\" to tell appearance preferences to get dark mode'")

  if handle then
    local result = handle:read("*a")
    handle:close()
    return result:match("true") ~= nil
  end

  return true
end

return M
