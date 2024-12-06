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
-- Spawn a zsh shell in login mode
-- config.default_prog = { "/bin/zsh", "-l" }
-- config.default_cwd = "/Users/brendanmcdonald/Documents/mmhmm-tv/"
--config.window_background_opacity = 0.9
config.macos_window_background_blur = 10
-- mux
config.leader = { key = "q", mods = "ALT", timeout_milliseconds = 2000 }
config.keys = {
	{ key = "l", mods = "ALT", action = wezterm.action.ShowLauncher },
	{ key = "e", mods = "CTRL", action = wezterm.action.EmitEvent("start-work") },
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
	local gitTab, gitPane = window:spawn_tab({ cwd = project_dir })
	gitPane:send_text("lazygit\n")
	local nodeTab, nodePane = window:spawn_tab({ cwd = project_dir })
	nodePane:send_text("npm run dev:tv\n")
	--
	pane:send_text("nvim ./\n")
	tab:activate()
	-- local editor_pane = pane:s\n")
	mux.set_active_workspace("work")
end)

-- and finally, return the configuration to wezterm
return config
