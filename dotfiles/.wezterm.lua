-- Pull in the wezterm API
local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.default_prog = { "/home/x/.nix-profile/bin/zsh", "--login", "-c", "tmux new-session -A -s main -t main" }

config.enable_tab_bar = false

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.font_size = 24.0
config.font = wezterm.font("DankMono Nerd Font Mono", { weight = "Bold" })
-- config.font = wezterm.font("AtkinsonHyperlegibleMono Nerd Font")
-- local fg = "#E3CA9A"
local fg = "#e8d4ae"
config.colors = {
	-- Default colors
	foreground = fg,
	background = "#131312",

	-- Normal colors
	ansi = {
		"#131312", -- black
		"#D0654B", -- red
		"#979764", -- green
		"#E3A138", -- yellow
		"#848A68", -- blue
		"#D97E4A", -- magenta
		"#799173", -- cyan
		"#E3CA9A", -- white
	},

	-- Bright colors
	brights = {
		"#575547", -- bright black
		"#D0654B", -- bright red
		"#979764", -- bright green
		"#E3A138", -- bright yellow
		"#848A68", -- bright blue
		"#D97E4A", -- bright magenta
		"#799173", -- bright cyan
		"#E8D2A9", -- bright white
	},

	-- Other settings from your config
	cursor_fg = "#131312",
	cursor_bg = fg,
	selection_fg = "#131312",
	selection_bg = fg,
}

local function tmux_prefix(key)
	local act = wezterm.action
	return act.Multiple({
		act.SendKey({ key = "a", mods = "CTRL" }),
		act.SendKey({ key = key }),
	})
end

local mod_key = "ALT"

config.keys = {
	{ key = "1", mods = mod_key, action = tmux_prefix("1") },
	{ key = "2", mods = mod_key, action = tmux_prefix("2") },
	{ key = "3", mods = mod_key, action = tmux_prefix("3") },
	{ key = "4", mods = mod_key, action = tmux_prefix("4") },
	{ key = "5", mods = mod_key, action = tmux_prefix("5") },
	{ key = "6", mods = mod_key, action = tmux_prefix("6") },
	{ key = "7", mods = mod_key, action = tmux_prefix("7") },
	{ key = "8", mods = mod_key, action = tmux_prefix("8") },
	{ key = "9", mods = mod_key, action = tmux_prefix("9") },
	{ key = "Enter", mods = mod_key, action = tmux_prefix("z") },
	{ key = "b", mods = mod_key, action = tmux_prefix("b") },
	{ key = "g", mods = mod_key, action = tmux_prefix("g") },
}

config.window_decorations = "TITLE"

return config
