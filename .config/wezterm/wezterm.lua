-- Pull in the wezterm API
local wezterm = require("wezterm")
local mux = wezterm.mux
-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = "Dracula (Official)"
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.window_decorations = "RESIZE"
config.font = wezterm.font("Dank Mono")
config.font_size = 16.0
config.max_fps = 165
-- Spawn a zsh shell in login mode
-- config.default_prog = { "/bin/zsh", "-l" }
-- config.default_cwd = "/Users/brendanmcdonald/Documents/mmhmm-tv/"
--config.window_background_opacity = 0.9
config.macos_window_background_blur = 10
-- mux
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = {
	{ key = "l", mods = "ALT", action = wezterm.action.ShowLauncher },
	{ key = "e", mods = "CTRL", action = wezterm.action.EmitEvent("start-work") },
	{ key = "-", mods = "LEADER", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	{ key = "\\", mods = "LEADER", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
	{ key = "s", mods = "LEADER", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	{ key = "v", mods = "LEADER", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
	{ key = "o", mods = "LEADER", action = "TogglePaneZoomState" },
	{ key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
	{ key = "c", mods = "LEADER", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
	{ key = "h", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
	{ key = "j", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
	{ key = "k", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
	{ key = "l", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
	{ key = "H", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Left", 5 } }) },
	{ key = "J", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Down", 5 } }) },
	{ key = "K", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Up", 5 } }) },
	{ key = "L", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Right", 5 } }) },
	{ key = "1", mods = "LEADER", action = wezterm.action({ ActivateTab = 0 }) },
	{ key = "2", mods = "LEADER", action = wezterm.action({ ActivateTab = 1 }) },
	{ key = "3", mods = "LEADER", action = wezterm.action({ ActivateTab = 2 }) },
	{ key = "4", mods = "LEADER", action = wezterm.action({ ActivateTab = 3 }) },
	{ key = "5", mods = "LEADER", action = wezterm.action({ ActivateTab = 4 }) },
	{ key = "6", mods = "LEADER", action = wezterm.action({ ActivateTab = 5 }) },
	{ key = "7", mods = "LEADER", action = wezterm.action({ ActivateTab = 6 }) },
	{ key = "8", mods = "LEADER", action = wezterm.action({ ActivateTab = 7 }) },
	{ key = "9", mods = "LEADER", action = wezterm.action({ ActivateTab = 8 }) },
	{ key = "&", mods = "LEADER|SHIFT", action = wezterm.action({ CloseCurrentTab = { confirm = true } }) },
	{ key = "d", mods = "LEADER", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },
	{ key = "x", mods = "LEADER", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },
}
-- config.keys = {
-- 	{
-- 		key = "9",
-- 		mods = "ALT",
-- 		action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|TABS" }),
-- 	},
-- }
-- tmux status
wezterm.on("update-right-status", function(window, _)
	local SOLID_LEFT_ARROW = ""
	local ARROW_FOREGROUND = { Foreground = { Color = "#BD93F9" } }
	local prefix = ""

	if window:leader_is_active() then
		prefix = " " .. utf8.char(0x1f30a) -- ocean wave
		SOLID_LEFT_ARROW = utf8.char(0xe0b2)
	end

	if window:active_tab():tab_id() ~= 0 then
		ARROW_FOREGROUND = { Foreground = { Color = "#282A36" } }
	end -- arrow color based on if tab is first pane

	window:set_left_status(wezterm.format({
		{ Background = { Color = "#ffb86c" } },
		{ Text = prefix },
		ARROW_FOREGROUND,
		{ Text = SOLID_LEFT_ARROW },
	}))
end)
wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window({})
	window:gui_window():maximize()
end)
wezterm.on("start-work", function(cmd)
	local args = {}
	if cmd then
		args = cmd.args
	end
	local project_dir = "/Users/brendanmcdonald/Documents/mmhmm-tv/"
	local tab, pane, window = mux.spawn_window({
		workspace = "work",
		cwd = project_dir,
		args = args,
	})
	local gitPane = pane:split({ size = 0.3 })
	gitPane:send_text("lazygit\n")
	local nodePane = gitPane:split({ args = { "bottom" } })
	nodePane:send_text("npm run dev:tv\n")
	pane:activate()
	pane:send_text("nvim ./\n")
	tab:set_zoomed()
	-- local gitTab, gitPane = window:spawn_tab({ cwd = project_dir })
	-- gitPane:send_text("lazygit\n")
	-- local nodeTab, nodePane = window:spawn_tab({ cwd = project_dir })
	-- nodePane:send_text("npm run dev:tv\n")
	-- --
	-- pane:send_text("nvim ./\n")
	-- tab:activate()
	-- -- local editor_pane = pane:s\n")
	mux.set_active_workspace("work")
end)

-- and finally, return the configuration to wezterm
return config
